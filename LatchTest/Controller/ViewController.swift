//
//  ViewController.swift
//  LatchTest
//
//  Created by lucas fernández on 18/01/2018.
//  Copyright © 2018 lucas fernández. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var switchLatch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var realoadButton: UIButton!
    
    let APP_ID: String = ""
    let APP_SECRET: String = ""
    var accountId: String!
    var latchInt: LatchInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountId = UserDefaults.standard.string(forKey: "app_id")
        if(self.accountId != nil){
            latchInt = LatchInterface(accountId: self.accountId, appId: APP_ID, appSecret: APP_SECRET)
            changeInterfaceStatus(enabled: true)
            checkStatusLatch()
        } else {
            changeInterfaceStatus(enabled: false)
        }
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.accountId = UserDefaults.standard.string(forKey: "app_id")
        if(self.accountId != nil){
            if(latchInt == nil){
                latchInt = LatchInterface(accountId: self.accountId, appId: self.APP_ID, appSecret: self.APP_SECRET)
            }
            changeInterfaceStatus(enabled: true)
            checkStatusLatch()
        } else {
            changeInterfaceStatus(enabled: false)
        }
    }
    
    
    
    func changeInterfaceStatus(enabled: Bool){
        DispatchQueue.main.async {
            if let arrayOfTabBarItems = self.tabBarController?.tabBar.items as! AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem {
                tabBarItem.isEnabled = enabled
            }
            self.switchLabel.text = enabled ? self.switchLabel.text : "No"
            self.switchLabel.textColor = enabled ? self.switchLabel.textColor : UIColor.gray
            self.switchLatch.setOn(enabled ? self.switchLatch.isOn : enabled, animated: true)
            self.realoadButton.isEnabled = enabled
            self.switchLatch.isEnabled = enabled
        }
    }
    
    
    
    
    @IBAction func checkStatusButton(_ sender: Any) {
        checkStatusLatch()
    }
    
    @IBAction func latchAction(_ sender: Any) {
        changeLock()
    }
    
    func changeLock() {
        if switchLatch.isOn {
            latchInt.lock()
            self.changeLabel(state: false)
        } else {
            latchInt.unlock()
            self.changeLabel(state: true)
        }
    }
    
    func checkStatusLatch() {
        latchInt.checkStatus { (status) in
            print(status)
            if(status == "on"){
               self.switchLatch.setOn(false, animated: true)
                self.changeLabel(state: true)
            } else {
                self.switchLatch.setOn(true, animated: true)
                self.changeLabel(state: false)
            }
        }
    }
    
    func changeLabel(state: Bool) {
        self.switchLabel.text = state ? "On" : "Off"
        self.switchLabel.textColor = state ? UIColor.black : UIColor.white
    }
}

