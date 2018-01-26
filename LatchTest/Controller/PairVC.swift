//
//  PairVC.swift
//  LatchTest
//
//  Created by lucas fernández on 26/01/2018.
//  Copyright © 2018 lucas fernández. All rights reserved.
//

import UIKit

class PairVC: UIViewController {
    
    @IBOutlet weak var pairInput: UITextField!
    let APP_ID: String = ""
    let APP_SECRET: String = ""
    var accountId: String!
    var latchInterface: LatchInterface!
    @IBOutlet weak var textPair: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountId = UserDefaults.standard.string(forKey: "app_id")
        self.accountId = self.accountId == nil ? "" : self.accountId
        latchInterface = LatchInterface(accountId: self.accountId, appId: self.APP_ID, appSecret: self.APP_SECRET)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pairButton(_ sender: Any) {
        latchInterface.pairLatch(token: pairInput.text!) { (account) in
            if (account != "error"){
                self.changeUIResponse(response: true)
                print(account)
                UserDefaults.standard.set(account, forKey: "app_id")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.changeUIResponse(response: false)
            }
        }
    }
    
    func changeUIResponse(response: Bool){
        DispatchQueue.main.async {
            self.textPair.text = response ? "Success" : "Error, try again"
            self.textPair.textColor = response ? UIColor.green : UIColor.red
        }
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
