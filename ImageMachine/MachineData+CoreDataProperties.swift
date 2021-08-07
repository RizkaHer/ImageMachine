//
//  MachineData+CoreDataProperties.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 06/08/21.
//
//

import Foundation
import CoreData


extension MachineData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MachineData> {
        return NSFetchRequest<MachineData>(entityName: "MachineData")
    }

    @NSManaged public var machineId: String?
    @NSManaged public var machineName: String?
    @NSManaged public var machineType: String?
    @NSManaged public var machineQRCode: String?
    @NSManaged public var lastMaintenanceDate: Date?

}

extension MachineData : Identifiable {

}
