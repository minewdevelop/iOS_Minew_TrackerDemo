//
//  DataManager.swift
//  MTTrackerKitDemo
//
//  Created by SACRELEE on 5/10/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

import UIKit

let trackersDataPath = NSHomeDirectory().appending("/Library/Trackers.archive")

class DataManager: NSObject {
    

    static func archiveTrackers(trackers: [String]) -> Void {
        
        if NSKeyedArchiver.archiveRootObject(trackers, toFile: trackersDataPath) {
            print("trackers archived!")
        }
        else {
            print("archive trackers failed.")
        }
    }
    
    static func unArchiveTrackers() -> [String]? {
        
        if FileManager.default.fileExists(atPath: trackersDataPath) == false {
            return nil
        }
        
        let trackers = NSKeyedUnarchiver.unarchiveObject(withFile: trackersDataPath) as? [String]
        return trackers
    }
}
