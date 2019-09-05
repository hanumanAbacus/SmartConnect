//
//  Constants.swift
//  SmartConnect
//
//  Created by Kheam Tan on 5/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import Foundation

struct TransactionConstant {
    // QR
    static let qrMerchantPurchase = "QR.Merchant.Purchase"
    static let qrConsumerPurchase = "QR.Consumer.Purchase"
    static let qrRefund = "QR.Refund"
    
    // journal
    static let reprintReceipt = "Journal.ReprintReceipt"

    // terminal
    static let getStatus = "Terminal.GetStatus"
    static let readCard = "Terminal.ReadCard"

    // acquirer
    static let logon = "Acquirer.Logon"
    static let settlementInquiry = "Acquirer.Settlement.Inquiry"
    static let settlementCutover = "Acquirer.Settlement.Cutover"

    // card
    static let purchase = "Card.Purchase"
    static let cardRefund = "Card.Refund"
    static let purchasePlusCash = "Card.PurchasePlusCash"
    static let cashAdvance = "Card.CashAdvance"
    static let authorise = "Card.Authorise"
    static let finalise = "Card.Finalise"

}


@objc public class TransactionConstants: NSObject {
    private override init() {}
    
    public class func merchantPurchase() -> String { return TransactionConstant.qrMerchantPurchase }
    public class func consumerPurchase() -> String { return TransactionConstant.qrConsumerPurchase }
    public class func qrRefund() -> String { return TransactionConstant.qrRefund }
    public class func reprintReceipt() -> String { return TransactionConstant.reprintReceipt }
    public class func getStatus() -> String { return TransactionConstant.getStatus }
    public class func readCard() -> String { return TransactionConstant.readCard }
    public class func logon() -> String { return TransactionConstant.logon }
    
    public class func settlementInquiry() -> String { return TransactionConstant.settlementInquiry }
    public class func settlementCutover() -> String { return TransactionConstant.settlementCutover }
    public class func purchase() -> String { return TransactionConstant.purchase }
    public class func cardRefund() -> String { return TransactionConstant.cardRefund }
    public class func purchasePlusCash() -> String { return TransactionConstant.purchasePlusCash }
    public class func cashAdvance() -> String { return TransactionConstant.cashAdvance }
    public class func authorise() -> String { return TransactionConstant.authorise }
    public class func finalise() -> String { return TransactionConstant.finalise }
}
