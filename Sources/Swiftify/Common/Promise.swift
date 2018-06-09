//
//  Promise.swift
//  Swiftify
//
//  Created by Tran Thien Khiem on 9/6/18.
//
import Foundation

/// Protocol for executable promise
protocol ExecutablePromise {
    func execute()
    func reject(error: Error)
}

/// Promise class - do a task in background and call back
public class Promise<Result>: ExecutablePromise {
    
    /// Chainable handler
    public typealias ChainableHandler<NextResult> = (Result) -> Promise<NextResult>
    
    /// function to resolve the promise
    public typealias ResolveFunction = (Result) -> Void
    
    /// function to reject the promise
    public typealias RejectFunction = (Error) -> Void
    
    /// function to execute promise
    public typealias ExecuteFunction = (@escaping ResolveFunction, @escaping RejectFunction) -> Void

    /// execution queue
    private let executionQueue: DispatchQueue
    
    /// call back queue
    private let callBackQueue: DispatchQueue
    
    /// the function to execute the promise
    private let task: ExecuteFunction
    
    /// function to handle the promise
    private var resolveHandler: ResolveFunction?
    
    /// function to reject the handler
    private var rejectHandler: RejectFunction?
    
    /// chainable promised if any
    private var chainedPromise: ExecutablePromise?
    
    /// the init function
    public init(_ task: @escaping ExecuteFunction,
         executionQueue: DispatchQueue = DispatchQueue.main,
         callBackQueue: DispatchQueue = DispatchQueue.main
    ) {
        self.task = task
        self.executionQueue = executionQueue
        self.callBackQueue = callBackQueue
    }

    /// execute function to execute the promise
    public func execute() {
        executionQueue.async {
            self.task(self.resolve, self.reject)
        }
    }
    
    /// Resolve the result
    ///
    /// - Parameter result: the result
    private func resolve(result: Result) {
        callBackQueue.async {
            self.resolveHandler?(result)
        }
    }
    
    /// Handle reject on the callback queue
    ///
    /// - Parameter error: the error passed to
    func reject(error: Error) {
        callBackQueue.async {
            self.rejectHandler?(error)
            self.chainedPromise?.reject(error: error)
        }
    }
    
    /// Then execute the next step
    ///
    /// - Parameter handler: execute next step
    public func then(_ handler: @escaping ResolveFunction) -> Promise<Result> {
        self.resolveHandler = handler
        return self
    }
    
    /// after this promise is fulfilled, continue with the other promise
    ///
    /// - Parameter task:
    /// - Returns: the next promise
    public func then<NextResult>(_ task: @escaping ChainableHandler<NextResult>) -> Promise<NextResult> {
        let chainedPromise = Promise<NextResult>({ resolved, reject in
            _ = self.then({ result in
                let nextPromise = task(result).then(resolved).onError(reject)
                nextPromise.execute()
            })
                .onError(self.reject)
            
            self.execute()
        })
        
        self.chainedPromise = chainedPromise
        return chainedPromise
    }
    
    /// Handle the error if happened
    ///
    /// - Parameter handler: the error handler
    /// - Returns: this promise
    public func onError(_ handler: @escaping RejectFunction) -> Promise<Result> {
        self.rejectHandler = handler
        return self
    }

}
