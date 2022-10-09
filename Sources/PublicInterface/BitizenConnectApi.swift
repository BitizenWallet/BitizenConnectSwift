//
//  BitizenConnectApi.swift
//  WalletConnectSwift
//
//  Created by yang chuang on 2022/9/27.
//  Copyright © 2022 Gnosis Ltd. All rights reserved.
//

import Foundation
import UIKit

public protocol BitizenConnectDelegate {
    func failedToConnect()
    func didConnect(chainId: Int?,accounts: [String]?)
    func didDisconnect()
}

public enum BitizenConnectState {
    case connectint
    case didConnect
    case none
}

open class BitizenConnectApi: NSObject {
    private var client: Client?
    private var wcUrl: WCURL?
    private var session: Session?
    private let sessionKey = "bitizen_connect_sdk_sessionKey"
    public var delegate: BitizenConnectDelegate?
    
    public var state:BitizenConnectState = BitizenConnectState.none;
        
    public init(delegate: BitizenConnectDelegate? = nil) {
        super.init()
        self.delegate = delegate
        reconnectIfNeeded()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
    
    private func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client?.reconnect(to: session)
        }
    }
    
    var url: URL?

    public func connect(dappName:String,dappDescription:String,dappUrl:URL) {
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://bridge.walletconnect.org")!,//wc的中继服务器，一般不需要进行修改
                           key: try! randomKey(), callbackUrl: "bitizenDapp://")
        let clientMeta = Session.ClientMeta(name: dappName,
                                            description: dappDescription,
                                            icons: [],
                                            url: dappUrl)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)
        try! client?.connect(to: wcUrl)

        let connectionUrl = wcUrl.absoluteString
        url = URL(string: connectionUrl)!;
    }
    
    public func personalSign(message: String,account:String,result:@escaping (_ response: Response) -> ()) {
        guard let url = session?.url else {
            return
        }
        try? client?.personal_sign(url: url, message: message, account: account) {
        response in
            result(response)
        }
    }
    
    public func ethSign(message: String,account:String,result:@escaping (_ response: Response) -> ()) {
        guard let url = session?.url else {
            return
        }
        try? client?.eth_sign(url: url, account: account, message: message) {
         response in
            result(response)
        }
    }
    
    public func ethSignTypedData(message: String,account:String,result:@escaping (_ response: Response) -> ()){
        guard let url = session?.url else {
            return
        }
        try? client?.eth_signTypedData(url: url,
                                      account: account,
                                      message: message) {
         response in
            result(response)
            
        }
    }
    
    public func ethSendTransaction(transaction:Client.Transaction,result:@escaping (_ response: Response) -> ()){
        guard let url = session?.url else {
            return
        }
        try? self.client?.eth_sendTransaction(url: url, transaction: transaction) {  response in
            result(response)
        }
    }
    
    public func disconnect() {
        guard let openSessions = client?.openSessions() else {
            return
        }
        for session in openSessions {
            try? client?.disconnect(from: session)
        }
    }
}


extension BitizenConnectApi: ClientDelegate {
        
    public func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate?.failedToConnect()
    }

    public func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
        guard let uri = self.url else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIApplication.shared.open(uri, options: [:])
        }
    }

    public func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate?.didConnect(chainId: session.walletInfo?.chainId, accounts: session.walletInfo?.accounts)
    }

    public func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate?.didDisconnect()
    }

    public func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}
