//
//  MockDataManager.swift
//  Metereader
//
//  Created by Shawn Roller on 9/16/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

struct MockDataManager: DataManagerProtocol {
    
    func getAddresses(forCustomer customer: String, completion: @escaping ([Address]) -> Void) {
        var addresses = [Address]()
        for i in 1...10 {
            let address = Address(nickname: "Address\(i)", address1: "\(i) Elm St", address2: "", city: "Nightmare", state: "OK", zip: "0800\(i)", country: "GB")
            addresses.append(address)
        }
        completion(addresses)
    }
    
    
    func getHistory(forCustomer customer: String, fromDate: Date, toDate: Date, completion: @escaping (_ response: [BillingHistory]) -> Void) {
        var history = [BillingHistory]()
        
        // paid history
        for i in 1...10 {
            var dateComponent = DateComponents()
            dateComponent.month = -i
            let paymentDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            
            dateComponent.month = -i - 1
            let statementDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            
            let total: Double = 300 - (Double(i) * 10)
            
            let bill = BillingHistory(statementDate: statementDate!, paymentDate: paymentDate!, dueDate: paymentDate!, totalBill: total, meterReading: 12345)
            history.append(bill)
        }
        
        // paid history
        for i in 0...2 {
            var dateComponent = DateComponents()
            dateComponent.month = i
            let statementDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            
            dateComponent.month = i + 1
            let dueDate = Calendar.current.date(byAdding: dateComponent, to: Date())
            
            let total: Double = 300 - (Double(i) * 10)
            
            let bill = BillingHistory(statementDate: statementDate!, paymentDate: nil, dueDate: dueDate!, totalBill: total, meterReading: 12345 + i)
            history.append(bill)
        }
        
        
        var dateComponent = DateComponents()
        dateComponent.month = -1
        let dueDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        let overdueBill = BillingHistory(statementDate: Date(), paymentDate: nil, dueDate: dueDate!, totalBill: 666, meterReading: 12345)
        history.append(overdueBill)
        
        completion(history.sorted(by: { $1.statementDate < $0.statementDate }))
    }
    
}
