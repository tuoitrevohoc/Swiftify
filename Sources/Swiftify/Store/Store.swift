//
//  Store.swift
//  Swiftify
//
//  Created by Tran Thien Khiem on 10/6/18.
//¬

import Foundation

/// An object that hold a state and handle all state changes
/// State should be codable so that it's able to store to database | local file
public class Store<State: Equatable, Action>: Observable<State> {
    
    /// Store handler, which receive the old state and action, calculate the next state
    public typealias Handler = (State, Action) -> State
    
    /// Dispatch function - used to dispatch a function to the store
    public typealias DispatchFunction = (Action) -> Void
    
    /// the handler function
    let handler: Handler
    
    /// the current state
    var state: State
    
    /// Initialize the store with a handler
    ///
    /// - Parameter handler: the handler object
    public init(initialState: State, handler: @escaping Handler) {
        self.state = initialState
        self.handler = handler
    }
    
    /// Calculate the state and dispatch to the queue
    ///
    /// - Parameter action: the action to call
    public func dispatch(action: Action) {
        let newState = handler(state, action)
        
        // if new state is different then invoke the event
        if newState != state {
            state = newState
            next(state)
        }
    }
    
}
