//
//  MyTrackerManager.swift
//  MTTrackerKitDemo
//
//  Created by SACRELEE on 5/8/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

import UIKit
import MTTrackit

class MyTrackerManager: NSObject {
    
    static let shared = MyTrackerManager()
    
    var bindTrackers = [MyTracker]()
    
    private var scannedTrackers = [String: MyTracker]()
    private let manager = MTTrackerManager.sharedInstance()
    
    override init() {
        super.init()
        self.initLogics()
    }
    
    func initLogics() -> Void {
        
      /**
        EN：please set a bind password, it's a string and the length is 8;
           it can contains Contains upper and lower case letters, numbers, and symbols.
           !!!Import: the app must remember the bind password, every time connect to the tracker need this password.
        
        ZH：请设置一个绑定密码，是一个字符串，它的长度必须为8，可以是大小写字母和数字的组合；
           !!!重要：在开发时，你的APP必须记住这个绑定密码，每一次连接都需要这个密码。
       */
        manager?.password = "12345678"
        
        assert(manager!.password.count == 8, "The password's length must be 8!")
        
        manager?.didChangeBluetooth({ (status) in
            print("The Bluetooth status change to: \(status)")
        })
        manager?.didChangeConnection({ (connection, tracker) in
            print("[\(String(describing: tracker!.name))] changes its connection status to (\(connection))")
        })
        
        guard let trackers = DataManager.unArchiveTrackers(), trackers.count > 0 else {
            return
        }
        
        for mac in trackers {
            let tracker =  manager?.addTracker(mac)
            let myTracker = MyTracker(tracker: tracker!)
            bindTrackers.append(myTracker)
        }
    }
    
    func startScan(completion: (([MyTracker])->Void)?) -> Void {
        manager?.startScan({ (trackers) in
            
            for tracker in trackers! {
                var myTracker = self.scannedTrackers[tracker.mac]
                
                if myTracker == nil {
                    myTracker = MyTracker(tracker: tracker)
                    self.scannedTrackers[tracker.mac] = myTracker
                }
                myTracker!.tracker = tracker
            }
            completion?(Array(self.scannedTrackers.values))
        })
    }
    
    func stopScan() -> Void {
        manager?.stopScan()
    }
    
    func bindValidate(myTracker: MyTracker, completion:@escaping ((Bool, Error?) -> Void)) -> Void {
        
        manager?.bindingVerify( myTracker.tracker, completion: { ( success, error) in
            if success {
               self.bindTrackers.append(myTracker)
                
                var bindMacs = [String]()
                for tracker in self.bindTrackers {
                    bindMacs.append(tracker.mac!)
                }
                DataManager.archiveTrackers(trackers: bindMacs)
            }
            completion(success, error)
        })
    }
    
    
    func unBindValidate(myTracker: MyTracker, index: Int, completion:@escaping ((Bool, Error?) -> Void)) -> Void {
        
        manager?.unbindTracker(myTracker.mac, completion: { (success, error) in
            if success {
                self.bindTrackers.remove(at: index)
                var bindMacs = [String]()
                for tracker in self.bindTrackers {
                    bindMacs.append(tracker.mac!)
                }
                DataManager.archiveTrackers(trackers: bindMacs)
            }
            completion(success, error)
        })
    }
    
    func removeTracker(mac: String) -> Void {
        manager?.removeTracker(mac)
    }
    
    func removeAllTracker() -> Void {
        manager?.removeAllTrackers()
    }
    
}
