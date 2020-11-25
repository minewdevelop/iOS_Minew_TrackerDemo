//
//  BindViewController.swift
//  MTTrackerKitDemo
//
//  Created by SACRELEE on 5/10/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

import UIKit
import SnapKit

class MyTableView: UITableView {
    var reloading = false
    
    override func reloadData() {
        if reloading {
            return
        }
        reloading = true
        super.reloadData()
        reloading = false
    }
}

class BindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    let manager = MyTrackerManager.shared
    var timer: Timer?
    var myTrackers: [MyTracker]?
    var binding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose a tracker"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Scan", style: UIBarButtonItem.Style.done, target: self, action: #selector(scanTrackers))
    }
    
    @objc func scanTrackers() -> Void {
        
        let title = self.navigationItem.rightBarButtonItem?.title!
        
        if title == "Scan" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(refreshViews), userInfo: nil, repeats: true)
            manager.startScan { (trackers) in
                
                if self.binding == false {
                    self.myTrackers = trackers
                }
            }
        }
        else {
            timer?.invalidate()
            manager.stopScan()
        }
        self.navigationItem.rightBarButtonItem?.title = title == "Scan" ? "Stop": "Scan"
    }
    
    @objc func refreshViews() -> Void {
        tableView.reloadData()
    }
    
    // MARK: tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myTrackers != nil ? self.myTrackers!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "identifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: identifier)
        
        cell.textLabel?.text = myTrackers![indexPath.row].mac
        cell.detailTextLabel?.text = "\(myTrackers![indexPath.row].tracker.rssi)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        binding = true
        
        let tracker = myTrackers![indexPath.row]
        
        manager.bindValidate(myTracker: tracker) { (success, error) in
            if success {
               self.navigationController?.popViewController(animated: false)
               let tvc = TrackerViewController()
               tvc.tracker = tracker
               self.navigationController?.pushViewController( tvc, animated: true)
            }
        }
        // bind tracker logics
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
