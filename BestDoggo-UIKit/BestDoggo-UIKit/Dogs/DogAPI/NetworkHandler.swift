//
//  NetworkHandler.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 02/10/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Network

protocol NetworkHandlerObserver: class {
    func statusDidChange(status: NWPath.Status)
}

class NetworkHandler {
    struct NetworkHandlerObservation {
        weak var observer: NetworkHandlerObserver?
    }
    
    //TODO: - NWPathMonitor instance
    private var monitor = NWPathMonitor()
    
    //TODO: - NetworkHandler shared instance
    private static let _sharedInstance = NetworkHandler()
    
    //TODO: - Observer collection
    private var observers = [ObjectIdentifier: NetworkHandlerObservation]()
    
    //TODO: - Current NWPathMonitor Status
    var currentStatus: NWPath.Status {
        get {
            return monitor.currentPath.status
        }
    }
    
    //TODO: - Shared Instance get function
    class func sharedInstance() -> NetworkHandler {
        return _sharedInstance
    }
    
    //TOOD: - init()
    init() {
        monitor.pathUpdateHandler = { [unowned self] path in
            //TODO: - Initialise observers
            for (id, observations) in self.observers {
                
                //If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    //TODO: - Remove observer
                    self.observers.removeValue(forKey: id)
                    continue
                }
                
                //TODO: - Async execution of statusDidChange
                DispatchQueue.main.async(execute: {
                    observer.statusDidChange(status: path.status)
                })
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    //TODO: - Add Observer
    func addObserver(observer: NetworkHandlerObserver) {
        let id = ObjectIdentifier(observer)
        observers[id] = NetworkHandlerObservation(observer: observer)
    }
    
    //TODO: - Remove Observer
    func removeObserver(observer: NetworkHandlerObserver) {
        let id = ObjectIdentifier(observer)
        observers.removeValue(forKey: id)
    }
}
