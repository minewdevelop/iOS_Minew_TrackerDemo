//
//  TrackerViewController.swift
//  MTTrackerKitDemo
//
//  Created by SACRELEE on 5/10/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

import UIKit
import SnapKit

class TrackerViewController: UIViewController {

    var tracker: MyTracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        for index in 0..<2 {
          
            let button = UIButton(type: .custom)
            self.view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 50, height: 80))
                make.centerX.equalTo(self.view).offset(index == 0 ? -60: 60)
                make.centerY.equalTo(self.view)
            }
            button.tag = index
            button.setTitle(index == 0 ? "RING" : "STOP", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        }
        
        let lossAlertSwitch = UISwitch.init()
        lossAlertSwitch.addTarget(self, action: #selector(writeLossAlert(sw:)), for: .valueChanged)
        self.view.addSubview(lossAlertSwitch)
        lossAlertSwitch.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(80)
        }
    }
    // MARK: ---------------------------switchBellStatus

    @objc func buttonClick(button: UIButton) -> Void {
        
        tracker?.tracker.switchBellStatus( button.tag == 0, completion: { (success, error) in
            if success {
                print("Switch the bell status success!")
            }
        })
    }
    
    // MARK: ---------------------------writeLossAlert

    @objc func writeLossAlert(sw: UISwitch) -> Void {
        
        tracker?.tracker.writeLossAlert(sw.isOn, completion: { (success, error) in
            if success {
                print("writeLossAlert success!")
            }
        })
    }
    
    //#WARNING:
    // MARK:---------------------------writeLossDelay
    //This part is Advanced APi, we provide it to the Advanced developers. Unless you understand the results of what these operations will lead to, don't try it lightly.
    // it means the tracker will alert after "delay" seconds since the tracker is disconnected.
    // please note: the range is 1s-7s, Too small value may cause false alert.
    @objc func writeLossDelay() -> Void {
        //delay 5s
        tracker?.tracker.writeLossDelay(5000, completion: { (success, error) in
            if success {
                print("writeLossDelay success!")
            }
        })
    }
    
    //#WARNING:
    // MARK: ---------------------------writeLossDistance
    // This parameter is the disconnect distance, the tracker will disconnect at that distance.
    // For example: is the level is "Far", the tracker will disconnect at 30m, "Middle": 20m,
    // "Near": 10m;
    // Please note the 30m/20m/10m above is not a real value, Because the actual environment is very complicated.
    // Three values: Far/Middle/Near for choosen, the default is "Far".
    @objc func writeLossDistance() -> Void {
        
        tracker?.tracker.writeLossDistance(.near, completion: { (success, error) in
            if success {
                print("writeLossDistance success!")
            }
        })
    }
    
    /*New features in F5
     
     Added the ability to modify device ringtones and query device ringtones in F5 devices.
     */
    
    // MARK: ---------------------------writeLossDeviceSound

    @objc func writeLossDeviceSound() -> Void {
        
        tracker?.tracker.writeLossDeviceSound(2, completion: { (success, error) in
            if success {
                print("writeLossDeviceSound success!")
            }
        })
    }
    
    // MARK: ---------------------------writeSelectLossDeviceSound

    @objc func writeSelectLossDeviceSound() -> Void {
        
        tracker?.tracker.writeSelectLossDeviceSound({ (x) in
            print(x)
        })
    }
    
    /*
     New features in F6

     Added mobile alarm switch and mobile alarm sensitivity gear settings in the F6 device and provided queries.

     */
    // MARK: ---------------------------writeMovingAlertLevelSetting

    @objc func writeMovingAlertLevelSetting() -> Void {
        //firmVersion Higher than 1.0.73 More sensitive
        tracker?.tracker.writeMovingAlertLevelSetting(2, completion: { (success, error) in
            if success {
                print("writeMovingAlertLevelSetting success!")
            }
        })
    }
    
    // MARK: ---------------------------writeSelectMovingAlertLevel

    @objc func writeSelectMovingAlertLevel() -> Void {
        
        tracker?.tracker.writeSelectMovingAlertLevel({ (x) in
            print(x)
        })
    }
    
    // MARK: ---------------------------writeMovingAlert

    @objc func writeMovingAlert(isMoving: Bool) -> Void {
        
        tracker?.tracker.writeMovingAlert(isMoving, completion: { (success, error) in
            if success {
                print("writeMovingAlert success!")
            }
        })
    }
    
    // MARK: ---------------------------writeSelectMovingAlert

    @objc func writeSelectMovingAlert() -> Void {
        
        tracker?.tracker.writeSelectMovingAlert({ (x) in
            print(x)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
