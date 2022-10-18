# BitizenConnectSwift

library to use BitizenConnect with Swift or Objective-C


## 相关配置

需要给您的APP配置deeplink或者Universal Links，建议您直接配置Universal Links

## 添加SDK依赖

可以通过Swift Package Manager和CocoaPods导入SDK，对应git地址为 https://github.com/BitizenWallet/BitizenConnectSwift.git

## 接入
```Swift
let api  =  BitizenConnectApi(delegate: self)
```
通过上方语句进行SDK的初始化，如果对应的SDK处于连接状态，则会进行自动连接

### 代理方法回调
    
```Swift    
    public protocol BitizenConnectDelegate {
        func failedToConnect() // 断开websocket链接
        func didConnect(chainId: Int?,accounts: [String]?) // 成功选择连接钱包,可能存在多个钱包地址
        func didDisconnect() // 断开和钱包的连接，针对于disconnect
    }
```

## 相关主动发起方法

* connect

```Swift
api.connect(dappName: "ExampleDapp", dappDescription: "BitizenConnectSwift", dappUrl: URL(string: "https://safe.gnosis.io")!,callbackUrl: "bitizenDapp://")

其中
dappName：dapp的名称
dappDescription：dapp的描述
dappUrl：dapp对应的链接
bitizenDapp：当前app的deeplink或者Universal Links，以便Bitizen产生相关结果后可以回调回到当前app
```

* ETH sign

```Swift

    api.ethSign(message: "0x0123", account: walletAccount) {  response in
            }

```
* Personal Sign
> eth_sign 是危险操作，会导致资金丢失，Bitizen Wallet 已经把 eth_sign 封禁
```Swift
              api.personalSign(message: "Hi there!", account: walletAccount) {  response in
            }
```
* Sign typed date
```Swift
    api.ethSignTypedData(message: Stub.typedData, account: walletAccount) { response in
            }
```

* ETH send transaction
```Swift
    api.ethSendTransaction(transaction: transaction) { response in
            }
    注意：这里的nonce直接传“0”就可以，APP端会根据重新获取所应该的nonce值
```
* Disconnect
```Swift
    api.disconnect()
```

* reconnectIfNeeded

如果连接钱包成功并且没有断开连接，只是websocket断开的话，可以通过此方法进行重连