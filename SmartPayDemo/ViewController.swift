//
//  ViewController.swift
//  SmartPayDemo
//
//  Created by Kheam Tan on 4/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import UIKit
import SmartConnect

class ViewController: UIViewController {
    let smartConnect = SmartConnect(pairingCode: "48138350", registerId: "1234567890", registerName: "ipad ipad ipad", businessName: "coffeedemoKK",vendorName: "Abacus POS", businessEnvironment: "staging")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        smartConnect.connect { (errorMessage) in
            self.smartConnect.terminalStatus(processing: { (result, errorMessage) in
                print(result)
            }, completion: { (result, errorMessage) in
                print(errorMessage)
                let requestData = SMTrasactionRequest()
                requestData.amount = (10)
                self.smartConnect.transaction(type: TransactionConstants.purchase(), requestData: requestData, processing: { (result, errorMessage) in
                    print(errorMessage)
                }, completion: { (result, errorMessage) in
                    print(result)
                })
            })
        }
    }


}

