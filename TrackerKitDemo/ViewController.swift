//
//  ViewController.swift
//  TrackerKitDemo
//
//  Created by Minewtech on 2020/11/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let tableView = UITableView()
    
    let manager = MyTrackerManager.shared
    var timer: Timer?
    var switchOff = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.startScan(completion: nil)
        
        self.title = "Trackers"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(refreshViews), userInfo: nil, repeats: true)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClick))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "stop"), style: .done, target: self, action: #selector(switchClick(barButton:)))
        // Do any additional setup after loading the view.
    }
    
    @objc func addClick() -> Void {
        self.navigationController?.pushViewController(BindViewController(), animated: true)
    }
    
    @objc func switchClick(barButton: UIBarButtonItem) -> Void {
        
        var image: UIImage?
        if switchOff == true {
            image = UIImage(named: "stop")
        }
        else {
            image = UIImage(named: "play")
        }
        barButton.image = image
        switchOff = !switchOff
    }
    
    @objc func refreshViews() -> Void {
        self.title = "Trackers(\(manager.bindTrackers.count))"
        tableView.reloadData()
    }
    
    // MARK: ---------------------------tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.bindTrackers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "identifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: identifier)
        
        cell.textLabel?.text = manager.bindTrackers[indexPath.row].mac
        cell.detailTextLabel?.text = manager.bindTrackers[indexPath.row].distanceString()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tvc = TrackerViewController()
        tvc.tracker = manager.bindTrackers[indexPath.row]
        self.navigationController?.pushViewController( tvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.unbind(tracker: manager.bindTrackers[indexPath.row], index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "delete"
    }
    // MARK: ---------------------------unbind

    func unbind(tracker:MyTracker, index:Int) {
        manager.unBindValidate(myTracker: tracker, index: index) { (success, error) in
            if success {
                self.tableView.reloadData()
            }
        }
    }


}

