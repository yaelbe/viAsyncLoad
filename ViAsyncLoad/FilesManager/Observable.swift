//
//  Observable.swift
//  ViAsyncLoad
//
//  Created by Yael Bilu Eran on 27/05/2020.
//  Copyright © 2020 CodeQueen. All rights reserved.
//

import Foundation

public typealias CancelSubscription = () -> (Void)


/// Tiny wrapper for property to be observable
public final class Observable<T> {
    
    private let lock = DispatchQueue(label: "com.observable.lock-queue", attributes: .concurrent)
    private var observers = NSHashTable<Observer>()
    typealias Handler = (T) -> Void
    private var _value: T
    

    /// Value
    var value: T {
        get { return lock.sync { return self._value } }
        set {
            let observers: [Observer] = lock.sync { () -> [Observer] in
                self._value = newValue
                return self.observers.allObjects
            }
            
            for observer in observers {
                if let queue = observer.callbackQueue {
                    queue.async {
                        observer.handler(newValue)
                    }
                } else {
                    lock.async {
                        observer.handler(newValue)
                    }
                    
                }
            }
        }
        
    }
    
    /// Subscribe to value changes
    ///
    /// - Parameter callback: runs every value changes
    /// - Returns: unsubscribe function
   
    public func subscribe(on callbackQueue: DispatchQueue? = nil, callback: @escaping (T) -> Void) -> CancelSubscription {
        let observer = Observer(callbackQueue: callbackQueue, handler: callback)
        
        lock.async {
            self.observers.add(observer)
        }
        return { [weak self] in self?.removeObserver(observer: observer) }
    }

    public init(_ value: T) {
        self._value = value
    }
    
    private final class Observer {
        let handler: Handler
        var conditionValue: T?
        var callbackQueue: DispatchQueue?
        
        init(callbackQueue: DispatchQueue?, handler: @escaping Handler) {
            self.callbackQueue = callbackQueue
            self.handler = handler
        }
    }
    
    
    private func removeObserver(observer: Observer) {
        lock.async { [weak self] in
            self?.observers.remove(observer)
        }
    }
}
