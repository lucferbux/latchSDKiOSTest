//
//  ExfiltrationVC.swift
//  LatchTest
//
//  Created by lucas fernández on 22/01/2018.
//  Copyright © 2018 lucas fernández. All rights reserved.
//

import UIKit

class ExfiltrationVC: UIViewController {
    
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var switch3: UISwitch!
    @IBOutlet weak var switch4: UISwitch!
    @IBOutlet weak var switch5: UISwitch!
    @IBOutlet weak var switch6: UISwitch!
    @IBOutlet weak var switch7: UISwitch!
    @IBOutlet weak var switch8: UISwitch!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var buttonRead: UIButton!
    
    
    var latchReader: LatchExfiltrationReader!
    var message = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let APP_ID = ""
        let APP_SECRET = ""
        let ACCOUNT_ID = ""
        
        latchReader = LatchExfiltrationReader(accountId: ACCOUNT_ID, appId: APP_ID, appSecret: APP_SECRET)
        message = ""
        self.buttonRead.setTitle("Read", for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func readMessage(_ sender: Any) {
        DispatchQueue.main.async {
            self.buttonRead.setTitle("Reading...", for: .normal)
        }
        latchReader.startExfiltration { (response) in
            self.messageLbl.text = ""
            self.readMessageLatch(operations: response)
        }


    }
    
    func readMessageLatch(operations: [String:String]) {
        self.latchReader.latch.checkStatus(operationId: operations["end"]!, completion: { (responseEnd) in
            if(responseEnd == "on"){
                self.latchReader.latch.checkStatus(operationId: operations["control"]!, completion: { (responseControl) in
                    if(responseControl == "off"){
                        self.latchReader.readExfiltratedByte(operation:1, ascii: "", dictConveted: operations, completion: { (responseExfiltration) in
                            DispatchQueue.main.async {
                                let responseAscci = responseExfiltration.1
                                let responseBits = responseExfiltration.0
                                self.parseByteToSwitch(byte: responseBits)
                                self.messageLbl.text = self.messageLbl.text! + responseAscci
                                self.latchReader.latch.unlock(operationId: operations["control"]!, completion: {
                                    self.readMessageLatch(operations: operations)
                                })
                            }
                        })
                    } else {
                        self.latchReader.latch.lock(operationId: operations["reader"]!)
                        let timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.callReadMessage), userInfo: operations, repeats: false)
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self.buttonRead.setTitle("Read", for: .normal)
                }
            }
        })
        
    }
    
    @objc func callReadMessage(timer:Timer){
        let operations = timer.userInfo as? [String:String]
        self.readMessageLatch(operations: operations!)
    }
    
    func parseByteToSwitch(byte: String) {
        if(byte.count == 8) {
            let byteArray = Array(byte)
            switch1.setOn(byteArray[0] == "1" ? true : false , animated: true)
            switch2.setOn(byteArray[1] == "1" ? true : false , animated: true)
            switch3.setOn(byteArray[2] == "1" ? true : false , animated: true)
            switch4.setOn(byteArray[3] == "1" ? true : false , animated: true)
            switch5.setOn(byteArray[4] == "1" ? true : false , animated: true)
            switch6.setOn(byteArray[5] == "1" ? true : false , animated: true)
            switch7.setOn(byteArray[6] == "1" ? true : false , animated: true)
            switch8.setOn(byteArray[7] == "1" ? true : false , animated: true)
        }
    }
    
}
