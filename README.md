# BitizenConnectSwift

## 相关配置
    需要给您的APP配置deeplink或者Universal Links，建议您直接配置Universal Links
## 接入
    let api  =  BitizenConnectApi(delegate: self)
    通过上方语句进行SDK的初始化，如果对应的SDK处于连接状态，则会进行自动连接

### 相关主动发起方法

* connect
    ```
    api.connect(dappName: "ExampleDapp", dappDescription: "BitizenConnectSwift", dappUrl: URL(string: "https://safe.gnosis.io")!)

    其中
    dappName 指的是对应dapp的名称
    dappDescription 指的是对dapp的描述
    dappUrl 指的是dapp对应的链接
    ```
* ETH sign
    ```
    api.ethSign(message: "0x0123", account: walletAccount) {  [weak self] response in
                self?.handleReponse(response, expecting: "Signature")
            }
    ```
* Personal Sign
    ```
              api.personalSign(message: "Hi there!", account: walletAccount) {  [weak self] response in
                self?.handleReponse(response, expecting: "Signature")
            }
    ```
* Sign typed date
    ```
    api.ethSignTypedData(message: Stub.typedData, account: walletAccount) {  [weak self] response in
                self?.handleReponse(response, expecting: "Signature")
            }
    ```
* ETH send transaction
    ```
    api.ethSendTransaction(transaction: transaction) {  [weak self] response in
                self?.handleReponse(response, expecting: "Hash")
            }
    注意：这里的nonce直接传“0”就可以，APP端会根据重新获取所应该的nonce值
    ```
* Disconnect
    ```
    api.disconnect()
    ```

## 代理方法回调
    
    public protocol BitizenConnectDelegate {
        func failedToConnect() // websocket 断开链接
        func didConnect(chainId: Int?,accounts: [String]?) // 成功选择链接钱包
        func didDisconnect() // 断开链接
    }
    
    
---


To start connections, you need to create and keep alive a `Client` object to which you provide `DappInfo` and a delegate:

```Swift
let client = Client(delegate: self, dAppInfo: dAppInfo)
```

The delegate then will receive calls when connection established, failed, or disconnected.

Upon successful connection, you can invoke various API methods on the `Client`.

```Swift
try? client.personal_sign(url: session.url, message: "Hi there!", account: session.walletInfo!.accounts[0]) {
      [weak self] response in
      // handle the response from Wallet here
  }
```

You can also send a custom request. The request ID required by JSON RPC is generated and handled by the library internally.

```Swift
try? client.send(Request(url: url, method: "eth_gasPrice")) { [weak self] response in
    // handle the response
}
```

You can convert the received response result to a `Decodable` type.

```Swift
let nonceString = try response.result(as: String.self)
```

You can also check if the wallet responded with error:

```Swift
if let error = response.error { // NSError
  // handle error
}
```

For more details, see the `ExampleApps/ClientApp`

# Running Example Apps

Please open `ExampleApps/ExampleApps.xcodeproj`

# Installation

## Prerequisites

- iOS 13.0 or macOS 10.14
- Swift 5

## BitizenConnectSwift dependencies

- CryptoSwift - for cryptography operations

## Swift Package Manager

In your `Package.swift`:

    dependencies: [
        .package(url: "https://github.com/BitizenWallet/BitizenConnectSwift.git", .upToNextMinor(from: "1.2.0"))
    ]

## CocoaPods

In your `Podfile`:

    platform :ios, '13.0'
    use_frameworks!

    target 'MyApp' do
      pod 'BitizenConnectSwift', :git => 'https://github.com/BitizenWallet/BitizenConnectSwift.git', :branch => 'master'
    end

## Carthage

In your `Cartfile`:

    github "BitizenConnect/BitizenConnectSwift"

Run `carthage update` to build the framework and drag the BitizenConnectSwift.framework in your Xcode project.

# License

MIT License (see the LICENSE file).
