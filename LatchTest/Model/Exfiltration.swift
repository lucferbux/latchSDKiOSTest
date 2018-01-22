//
//  Exfiltration.swift
//  LatchTest
//
//  Created by lucas fernández on 22/01/2018.
//  Copyright © 2018 lucas fernández. All rights reserved.
//

import Foundation

class LatchExfiltration {
    
    private var _latches = ["1", "2", "3", "4", "5", "6", "7", "8", "control", "reader", "end"]
    let latch: LatchInterface
    let accountId: String
    
    init(accountId: String, appId: String, appSecret: String) {
        self.accountId = accountId
        self.latch = LatchInterface(accountId: accountId, appId: appId, appSecret: appSecret)
    }
    
    func startExfiltration(completion: @escaping ([String:String]) -> Void){
        latch.getOperations(completion: { (response) in
            let dictConverted = self.convertDict(dict: response)
            DispatchQueue.global(qos: .userInitiated).async {
                self.latch.unlockAll(operations: dictConverted)
            }
            completion(dictConverted)
        })
    }
    
    func convertDict(dict: [String:Any]) -> [String:String] {
        var finalDictionary = [String:String]()
        for (key, value) in dict {
            guard let valueDict = value as? [String:Any],
                let name = valueDict["name"] as? String else {
                    print("Error conversion failed")
                    return ["Error" : "Conversion Failed"]
            }
            finalDictionary[name] = key
        }
        print(finalDictionary)
        return finalDictionary
    }
    
    func readStringToByte(message: String) -> [String] {
        let buf: [UInt8] = Array(message.utf8)
        let bufstr: [String] = buf.map() {pad(string: String($0, radix:2), toSize: 8)}
        return bufstr
    }
    
    func byteToString(byte: String) -> String {
        return String(UnicodeScalar(UInt8(byte, radix: 2)!))
    }
    
    
    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<(toSize - string.count) {
            padded = "0" + padded
        }
        return padded
    }
    

    
    
    
    
    
}




