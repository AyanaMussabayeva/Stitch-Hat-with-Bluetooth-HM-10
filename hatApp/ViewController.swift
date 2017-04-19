//
//  ViewController.swift
//  hatApp
//
//  Created by Apple on 4/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothSerialDelegate {
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    var selectedPeripheral: CBPeripheral?
    
    @IBOutlet var deviceTableView: UITableView!
    @IBOutlet var tryAgainButton: UIButton!
    @IBOutlet var alertLabel: UILabel!
    
    @IBAction func cancelTapped(_ sender: Any) {
        serial.stopScan()
        dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        // empty array an start again
        peripherals = []
        deviceTableView.reloadData()
        tryAgainButton.isEnabled = false
        title = "Scanning..."
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.scanTimeOut), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init serial
        
        serial = BluetoothSerial(delegate: self)
        serial.delegate = self
        
        if serial.centralManager.state != .poweredOn {
            title = "Bluetooth not turned on"
            return
        }
        
        // tryAgainButton is only enabled when we've stopped scanning
        tryAgainButton.isEnabled = false
        //scanning
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.scanTimeOut), userInfo: nil, repeats: false)

    }
    func scanTimeOut() {
        // timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
        tryAgainButton.isEnabled = true
        title = "Done scanning"
    }
    
    func connectTimeOut() {
        
        // don't if we've already connected
        if let _ = serial.connectedPeripheral {
            return
        }
        if let _ = selectedPeripheral {
            serial.disconnect()
            selectedPeripheral = nil
        }
        alertLabel.text = "ooops, failed to connect"
    }
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return a cell with the peripheral name as text in the label
        let cell = deviceTableView.dequeueReusableCell(withIdentifier: "cell")!
        let label = cell.viewWithTag(1) as! UILabel!
        label?.text = peripherals[(indexPath as NSIndexPath).row].peripheral.name
        return cell
    }
    
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        deviceTableView.deselectRow(at: indexPath, animated: true)
        
        // the user has selected a peripheral, so stop scanning and proceed to the next view
        serial.stopScan()
        selectedPeripheral = peripherals[(indexPath as NSIndexPath).row].peripheral
        serial.connectToPeripheral(selectedPeripheral!)
        alertLabel.text = "connecting"
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.connectTimeOut), userInfo: nil, repeats: false)
    }
    //MARK: BluetoothSerialDelegate
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort & reload
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append(peripheral: peripheral, RSSI: theRSSI)
        peripherals.sort { $0.RSSI < $1.RSSI }
        deviceTableView.reloadData()
    }

    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
        tryAgainButton.isEnabled = true
        alertLabel.text = " failed to connect"
    }
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        tryAgainButton.isEnabled = true
        alertLabel.text = " failed to connect"
        
    }
    func serialIsReady(_ peripheral: CBPeripheral) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
        dismiss(animated: true, completion: nil)
    }
    func serialDidChangeState() {
        if serial.centralManager.state != .poweredOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func serialDidConnect(_ peripheral: CBPeripheral) {
        performSegue(withIdentifier: "goToMain",  sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   

}

