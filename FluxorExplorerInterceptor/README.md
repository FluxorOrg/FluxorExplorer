# FluxorExplorerInterceptor

An [Interceptor](https://github.com/FluxorOrg/Fluxor/blob/master/Sources/Fluxor/Interceptor.swift)  to register on a [Fluxor](https://github.com/FluxorOrg/Fluxor) [Store](https://github.com/FluxorOrg/Fluxor/blob/master/Sources/Fluxor/Store.swift). When registered it will send [FluxorExplorerSnapshots](https://github.com/FluxorOrg/FluxorExplorerSnapshot) to [FluxorExplorer](https://github.com/FluxorOrg/FluxorExplorer).

![Platforms](https://img.shields.io/badge/platforms-Mac+iOS-brightgreen.svg?style=flat)
![Swift version](https://img.shields.io/badge/Swift-5.2-brightgreen.svg)
![Swift PM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)
![Twitter](https://img.shields.io/badge/twitter-@mortengregersen-blue.svg?style=flat)

![Test](https://github.com/FluxorOrg/FluxorExplorerInterceptor/workflows/CI/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/fe7eab769644c665f08a/maintainability)](https://codeclimate.com/github/FluxorOrg/FluxorExplorerInterceptor/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/fe7eab769644c665f08a/test_coverage)](https://codeclimate.com/github/FluxorOrg/FluxorExplorerInterceptor/test_coverage)

## ⚙️ Usage
To get started with FluxorExplorerInterceptor, just register an instance of it on the  Store in an app.

The only thing needed, for FluxorExplorer to receive all actions and state changes from an app, is to register the `FluxorExplorerInterceptor` in the app's [Fluxor](https://github.com/FluxorOrg/Fluxor) `Store`. When [FluxorExplorer](https://github.com/FluxorOrg/FluxorExplorer) and the app are running on the same network (eg. running the app on the iOS Simulator), they will automatically connect and transmit data.

```swift
let store = Store(initialState: AppState())
#if DEBUG
store.register(interceptor: FluxorExplorerInterceptor(displayName: UIDevice.current.name))
#endif
```

**NOTE:** It is recommended to only register the interceptor in `DEBUG` builds.
