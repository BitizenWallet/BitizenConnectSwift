# BitizenConnectSwift

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
        .package(url: "https://github.com/BitizenConnect/BitizenConnectSwift.git", .upToNextMinor(from: "1.2.0"))
    ]

## CocoaPods

In your `Podfile`:

    platform :ios, '13.0'
    use_frameworks!

    target 'MyApp' do
      pod 'BitizenConnectSwift', :git => 'https://github.com/BitizenConnect/BitizenConnectSwift.git', :branch => 'master'
    end

## Carthage

In your `Cartfile`:

    github "BitizenConnect/BitizenConnectSwift"

Run `carthage update` to build the framework and drag the BitizenConnectSwift.framework in your Xcode project.

# License

MIT License (see the LICENSE file).
