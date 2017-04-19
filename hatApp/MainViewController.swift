//
//  MainViewController.swift
//  hatApp
//
//  Created by Apple on 4/15/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController, BluetoothSerialDelegate {

    @IBAction func move3(_ sender: Any) {
        let msg = "3" + "\n"
        serial.sendMessageToDevice(msg)
    }
    @IBAction func move2(_ sender: Any) {
        let msg = "2" + "\n"
        serial.sendMessageToDevice(msg)
    }
    @IBAction func move1(_ sender: Any) {
        let msg = "1" + "\n"
         serial.sendMessageToDevice(msg)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init serial
        serial.delegate = self
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
