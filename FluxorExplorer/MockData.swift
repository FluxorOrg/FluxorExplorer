/**
 * FluxorExplorer
 *  Copyright (c) Morten Bjerg Gregersen 2020
 *  MIT license, see LICENSE file for details
 */

#if DEBUG
import Fluxor
import FluxorExplorerSnapshot
import MultipeerConnectivity

// swiftlint:disable trailing_comma

func setupMockData() {
    let peer1 = MCPeerID(displayName: "iPhone 11 Pro")
    let peer2 = MCPeerID(displayName: "iPhone 8")
    let snapshots = createSnapshots()
    Current.store.register(reducer: createReducer(
        reduceOn(ResetStateAction.self) { state, _ in
            state = AppState()
        }
    ))
    Current.store.dispatch(action: ResetStateAction())
    Current.store.dispatch(action: PeerConnectedAction(peer: peer1))
    Current.store.dispatch(action: PeerConnectedAction(peer: peer2))
    snapshots.forEach {
        Current.store.dispatch(action: DidReceiveSnapshotAction(peer: peer1, snapshot: $0))
    }
}

private var oldDate = Date()
private var oldState = SampleAppState(todos: TodosState(loadingTodos: false))

private func createSnapshots() -> [FluxorExplorerSnapshot] {
    var todos = [
        Todo(title: "Dispatch actions"),
        Todo(title: "Create effects"),
        Todo(title: "Select something"),
        Todo(title: "Intercept everything"),
    ]
    let newTodoTitle = "Buy milk"
    return [
        createSnapshot(action: FetchTodosAction(), newState: SampleAppState(todos: TodosState(loadingTodos: true))),
        createSnapshot(action: DidFetchTodosAction(todos: todos),
                       newState: SampleAppState(todos: TodosState(todos: todos, loadingTodos: false))),
        createSnapshot(action: CompleteTodoAction(todo: todos[0]),
                       newState: SampleAppState(todos: TodosState(todos: { todos[0].done = true; return todos }(),
                                                                  loadingTodos: false))),
        createSnapshot(action: AddTodoAction(title: newTodoTitle),
                       newState: SampleAppState(todos: TodosState(todos: {
                           todos.append(Todo(title: newTodoTitle)); return todos
        }(), loadingTodos: false))),
        createSnapshot(action: CompleteTodoAction(todo: todos[1]),
                       newState: SampleAppState(todos: TodosState(todos: { todos[1].done = true; return todos }(),
                                                                  loadingTodos: false))),
        createSnapshot(action: UncompleteTodoAction(todo: todos[1]),
                       newState: SampleAppState(todos: TodosState(todos: { todos[1].done = false; return todos }(),
                                                                  loadingTodos: false))),
    ]
}

private func createSnapshot(action: Action, newState: SampleAppState) -> FluxorExplorerSnapshot {
    let date = oldDate.addingTimeInterval(TimeInterval.random(in: 1...5))
    defer {
        oldState = newState
        oldDate = date
    }
    return FluxorExplorerSnapshot(action: action, oldState: oldState, newState: newState, date: date)
}

private struct SampleAppState: Encodable {
    var todos = TodosState()
}

private struct TodosState: Encodable {
    var todos = [Todo]()
    var loadingTodos = false
    var error: String?
}

private struct FetchTodosAction: Action {}

private struct DidFetchTodosAction: Action {
    let todos: [Todo]
}

private struct AddTodoAction: Action {
    let title: String
}

private struct CompleteTodoAction: Action {
    let todo: Todo
}

private struct UncompleteTodoAction: Action {
    let todo: Todo
}

private struct DeleteTodoAction: Action {
    let index: Int
}

private struct ResetStateAction: Action {}

private struct Todo: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    var done = false

    init(title: String) {
        id = UUID()
        self.title = title
    }
}

#endif
