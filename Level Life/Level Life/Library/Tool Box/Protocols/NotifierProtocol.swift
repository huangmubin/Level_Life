//
//  NotifierProtocol.swift
//  NetworkTestProject
//
//  Created by 黄穆斌 on 2017/3/17.
//  Copyright © 2017年 MuBinHuang. All rights reserved.
//

import Foundation

// MARK: - Notifier Ptorocol

/**
 Easy notifier method.
 */
public protocol NotifierProtocol { }
extension NotifierProtocol {
    
    /** Observer a notify. */
    @discardableResult
    func observer(name: NSNotification.Name, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: using)
    }
    
    /** Observer a notify. */
    func observer(name: NSNotification.Name, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: object)
    }
    
    /** remove observer a notify. */
    func unobserver(name: NSNotification.Name?, object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: name, object: object)
    }
    
    /** Post a notify. */
    func post(name: NSNotification.Name, infos: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: self, userInfo: infos)
    }
    
    /** Post a notify in specific queue. */
    func post(name: NSNotification.Name, infos: [AnyHashable: Any]? = nil, inQueue: DispatchQueue) {
        inQueue.async {
            NotificationCenter.default.post(name: name, object: self, userInfo: infos)
        }
    }
}

extension NotifierProtocol {
    
    /** Observer a notify. */
    @discardableResult
    func observer(_ name: String, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: NSNotification.Name.init(name), object: object, queue: queue, using: using)
    }
    
    /** Observer a notify. */
    func observer(_ name: String, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name.init(name), object: object)
    }
    
    /** remove observer a notify. */
    func unobserver(_ name: String? = nil, object: Any? = nil) {
        if name == nil {
            NotificationCenter.default.removeObserver(self, name: nil, object: object)
        } else {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(name!), object: object)
        }
    }
    
    /** Post a notify. */
    func post(_ name: String, infos: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: NSNotification.Name.init(name), object: self, userInfo: infos)
    }
    
    /** Post a notify in specific queue. */
    func post(_ name: String, infos: [AnyHashable: Any]? = nil, inQueue: DispatchQueue) {
        inQueue.async {
            NotificationCenter.default.post(name: NSNotification.Name.init(name), object: self, userInfo: infos)
        }
    }
    
}

// MARK: - Notify Object

extension Notification {
    
    private func open_info(keys: [Any]) -> Any? {
        if let infos = userInfo {
            var temp: Any? = infos
            for key in keys {
                if let json = temp as? [String: Any],
                    let key = key as? String {
                    temp = json[key]
                }
                else if let json = temp as? [Any],
                    let key = key as? Int {
                    temp = json[key]
                }
            }
            return temp
        }
        return nil
    }
    
    /**
     Get the data with key.
     - parameter keys: some String or Int key. like [1, "key", 2]
     - parameter null: if nil
     - returns: the T type data, if nill return the null
     */
    public func get<T>(_ keys: Any..., null: T) -> T {
        if let value = open_info(keys: keys) as? T {
            return value
        }
        return null
    }
    
    
    /**
     Get the data with key.
     - parameter keys: some String or Int key. like [1, "key", 2]
     - returns: the T type data, if nill return nil
     */
    public func get<T>(_ keys: Any...) -> T? {
        if let value = open_info(keys: keys) as? T {
            return value
        }
        return nil
    }
    
    
}
