//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation

public struct WCURL: Hashable, Codable {
    // topic is used for handshake only
    public var topic: String
    public var version: String
    public var bridgeURL: URL
    public var key: String
    public var callbackUrl: String

    public var absoluteString: String {
        let bridge = bridgeURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return "https://bitizen.org/wallet/wc?uri=wc:\(topic)@\(version)?bridge=\(bridge)&key=\(key)&callbackUrl=\(callbackUrl)"
    }

    public init(topic: String,
                version: String = "1",
                bridgeURL: URL,
                key: String,
                callbackUrl: String) {
        self.topic = topic
        self.version = version
        self.bridgeURL = bridgeURL
        self.key = key
        self.callbackUrl = callbackUrl
    }
}
