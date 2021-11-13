/*
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2021
 *  MIT license, see LICENSE file for details
 */

import Fluxor
import SwiftUI

@main
struct FluxorExplorerApp: App {
    static var store: Store<AppState, AppEnvironment> = {
        let store = Store(initialState: AppState(), environment: AppEnvironment())
        store.register(reducer: appReducer)
        store.register(effects: AppEffects())
        #if DEBUG
        store.register(interceptor: PrintInterceptor())
        #endif
        return store
    }()

    static let sessionHandler = SessionHandler()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                PeersView()
                SnapshotsView()
                Text("Select a snapshot in the list")
            }
            .environmentObject(FluxorExplorerApp.store)
            .onAppear {
                Self.store.dispatch(action: Actions.startSessionHandler())
                #if DEBUG
                // When using scenes, the app isn't relaunched with the environment variable.
                // So we set a user default, to ensure the mock data is setup on subsequent launches.
                let defaultsKey = "STARTED_FROM_UI_TEST"
                if ProcessInfo.processInfo.environment["UI_TESTING"] != nil
                    || UserDefaults.standard.bool(forKey: defaultsKey) {
                    setupMockData()
                    UserDefaults.standard.set(true, forKey: defaultsKey)
                }
                #endif
            }
        }
    }
}
