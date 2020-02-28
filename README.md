# FluxorExplorer

**A macOS and iPadOS app for exploring dispatched `Action`s and state changes in apps using [Fluxor](https://github.com/MortenGregersen/Fluxor).**

![Platforms](https://img.shields.io/badge/platforms-Mac+iOS-brightgreen.svg)
![Swift version](https://img.shields.io/badge/Swift-5.1-brightgreen.svg)
![Swift PM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)
![Twitter](https://img.shields.io/badge/twitter-@mortengregersen-blue.svg)

![](https://github.com/MortenGregersen/FluxorExplorer/blob/master/Assets/FluxorExplorer.png)

FluxorExplorer allows developers of apps using Fluxor, to step through the actions dispatched and the corresponding state changes, to easily debug the data flow of their app.

## 🗣 Make your app talk

The only thing you need to do, to make your app send out the dispatched actions and state changes, is to register the [FluxorExplorerInterceptor](https://github.com/MortenGregersen/FluxorExplorerInterceptor) in the store:

```swift
let store = Store(initialState: AppState())
#if DEBUG
store.register(interceptor: FluxorExplorerInterceptor(displayName: UIDevice.current.name))
#endif
```

**Note:** It is recommended that the FluxorExplorerInterceptor is only registered in debug builds.

## 🔌 How does it connect?

FluxorExplorer and FluxorExplorerInterceptor uses Apple's [MultipeerConnectivity](https://developer.apple.com/documentation/multipeerconnectivity) framework to connect and communicate.

1. When FluxorExplorer is launched, it instantiates a [`MCNearbyServiceBrowser`](https://developer.apple.com/documentation/multipeerconnectivity/mcnearbyservicebrowser) and starts browsing for peers.
2. When a FluxorExplorerInterceptor is instantiated a [`MCNearbyServiceAdvertiser`](https://developer.apple.com/documentation/multipeerconnectivity/mcnearbyserviceadvertiser) and starts advertising.
3. When FluxorExplorer discovers an advertising peer it automatically sends an invite to the peer
4. When the advertising FluxorExplorerInterceptor receives an invite, it automatically accepts it

This means that as long as FluxorExplorer and the app using FluxorExplorerInterceptor is on the same network, they will automatically connect and send/receive data.