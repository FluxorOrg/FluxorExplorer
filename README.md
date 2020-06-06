<div align="center">
	<img src="https://raw.githubusercontent.com/FluxorOrg/FluxorExplorer/master/Assets/MacIcon-256.png">
	<h1>FluxorExplorer</h1>
	<p style="font-weight: bold">A macOS and iPadOS app for debugging apps using <a href="https://github.com/FluxorOrg/Fluxor">Fluxor</a>.
	</p>
	<img src="https://img.shields.io/badge/platforms-Mac+iOS-brightgreen.svg" alt="Platform: Mac+iOS">
	<img src="https://img.shields.io/badge/Swift-5.2-brightgreen.svg" alt="Swift 5.2">
	<a href="https://twitter.com/mortengregersen">
		<img src="https://img.shields.io/badge/twitter-@mortengregersen-blue.svg" alt="Twitter: @mortengregersen">
	</a>
	<br />
	<a href="https://app.bitrise.io/app/635aaa9da78fe2ea">
		<img src="https://app.bitrise.io/app/635aaa9da78fe2ea/status.svg?token=caKliqXorMigOCRwS8tFqw&branch=master" alt="Build Status" />
	</a>
	<a href="https://codeclimate.com/github/FluxorOrg/FluxorExplorer/maintainability">
		<img src="https://api.codeclimate.com/v1/badges/2eb653fd95cde6754b33/maintainability" alt="Maintainability" />
	</a>
	<a href="https://codeclimate.com/github/FluxorOrg/FluxorExplorer/test_coverage">
		<img src="https://api.codeclimate.com/v1/badges/2eb653fd95cde6754b33/test_coverage" alt="Test Coverage" />
	</a>
</div>

![](https://raw.githubusercontent.com/FluxorOrg/FluxorExplorer/master/Assets/FluxorExplorer.png)

FluxorExplorer allows developers of apps using Fluxor, to step through the actions dispatched and the corresponding state changes, to easily debug the data flow of their app.

## 🗣 Make your app talk

The only thing you need to do, to make your app send out the dispatched actions and state changes, is to register the [FluxorExplorerInterceptor](https://github.com/FluxorOrg/FluxorExplorerInterceptor) in the store:

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
