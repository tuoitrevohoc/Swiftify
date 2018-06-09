//
//  Obserable.swift
//  Swiftify
//
//  Created by Tran Thien Khiem on 9/6/18.
//

import Foundation

/// Observable type
public protocol ObservableType {
    /// event of this type
    associatedtype Event
    
    /// Subscribe
    ///
    /// - Parameters:
    ///   - listener: the listener
    ///   - handler: handler
    func subscribe(as listener: NSObject, handler: @escaping (Event) -> Void)
    
    /// Unsubscribe from the observable
    ///
    /// - Parameter listener: the listener object
    func unsubscribe(as listener: NSObject)
}

/// An obserable for listening to an event
public class Observable<Event>: ObservableType {
    
    /// Listening function
    public typealias ListeningFunction = (Event) -> Void

    /// list of handlers
    var listeners: [NSObject:ListeningFunction] = [:]
    
    /// initialize
    public init() {
    }
    
    /// Subscribe to this observable
    ///
    /// - Parameters:
    ///   - listener: the listener
    ///   - handler: handler
    public func subscribe(as listener: NSObject, handler: @escaping ListeningFunction) {
        listeners[listener] = handler
    }
    
    /// Remove this from listeners
    ///
    /// - Parameter listener: the listener to remove
    public func unsubscribe(as listener: NSObject) {
        listeners.removeValue(forKey: listener)
    }
    
    /// Incoming event. invoke all listeners
    ///
    /// - Parameter event: the incoming event
    public func next(_ event: Event) {
        listeners.values.forEach({ $0(event) })
    }
}
