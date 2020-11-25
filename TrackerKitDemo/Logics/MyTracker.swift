//
//  MyTracker.swift
//  MTTrackerKitDemo
//
//  Created by SACRELEE on 5/8/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

import UIKit
import MTTrackit

class MyTracker: NSObject {
    
    var name: String?
    var mac: String?
    
    private var _tracker: MTTracker?
    var tracker: MTTracker {
        set(newTracker){
            
           _tracker = newTracker
            
           _tracker?.didReceive { (received) in
             print("Received a Event from tracker：\(received.rawValue)")
            
             if received == Receiving.buttonPushed {
                DispatchQueue.main.async(execute: {
                    if let value = self.mac {
                        Toast.show(message: "[\(value)] Calls iPhone.")
                    }
                })
             }
           }
            
           _tracker?.didValueUpdate {
             print("Did tracker updated its value")
           }
            
           _tracker?.didConnectionChange { (connection) in
            print("Did tracker change Connection:\(connection.rawValue)")
            
            guard ( connection == Connection.connected || connection == Connection.disconnected ) else {
                return
            }
            
              DispatchQueue.main.async(execute: {
                  if let value = self.mac {
                    Toast.show(message: "[\(value)] did \(connection == Connection.connected ? "Connected" : "Disconnected" ).")
                  }
              })
           }
        }
        get {
            return _tracker!
        }
    }
    
    func distanceString() -> String {
        
        switch tracker.distance {
        case .far:
         return "Far"
        case .middle:
         return "Near"
        case .near:
         return "Around"
        case .validating:
         return "Validating"
        case .undefined:
         return "Disconnected"
        @unknown default:
         return "Unknown"
        }
    }
    
    override init() {
        super.init()
    }
    
    init(tracker: MTTracker) {
        super.init()
        self.tracker = tracker
        self.mac = tracker.mac
    }
}
