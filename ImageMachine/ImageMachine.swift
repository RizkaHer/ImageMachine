//
//  ImageMachine.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 07/08/21.
//

import Foundation
import UIKit

class ImageMachineModel : NSObject {
    private var createdDate : Date {
        return Date()
    }
    private var dataId : String = ""
    var machineId : String {
        get{
            return dataId
        }
        set {
            dataId = newValue
        }
    }
    private var dataQR : String = ""
    var machineQRCode : String {
        get {
            return dataQR
        }
        set {
            dataQR = newValue
        }
    }
    var machineName : String?
    var machineType : String?
    
    var machineLastMaintenanceDate : Date?
    var machineImages : [UIImage]?
}

extension ImageMachineModel {
    func initNewImageMachine() {
        dataId = generateID()
        dataQR = generateQRCode()
    }
    private func generateID()-> String {
        let unixtime = createdDate.timeIntervalSince1970
        let unixString = String(unixtime).prefix(10)
        var randNoString = ""
        for _ in 0...7 {
            let randNo = Int.random(in: 0..<10)
            randNoString += String(randNo)
        }
        return unixString+randNoString
    }
    
    private func generateQRCode()-> String {
        let createdDateString = getCreatedStringDate(currentDate: createdDate)
        return "01\(machineId)02\(createdDateString)"
    }
    
    private func getCreatedStringDate(currentDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: currentDate)
    }
}

