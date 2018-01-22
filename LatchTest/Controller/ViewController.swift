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
    
    
    var latchInt: LatchInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let APP_ID = ""
        let APP_SECRET = ""
        let ACCOUNT_ID = ""
        latchInt = LatchInterface(accountId: ACCOUNT_ID, appId: APP_ID, appSecret: APP_SECRET)
        checkStatusLatch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkStatusLatch()
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

