//
//  ImageMachineDataModel.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 07/08/21.
//

import UIKit
import CoreData

class ImageMachineDataModel: NSObject {
    private var imageMachineData : [ImageMachineModel]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func selectData(sortBy: String) -> [ImageMachineModel]? {
        do {
            let machineData = try context.fetch(getSortedRequest(sortBy: sortBy))
            imageMachineData = convertDataModelToData(dataModel: machineData)
            return imageMachineData
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func convertDataModelToData(dataModel:[MachineData])-> [ImageMachineModel]? {
        imageMachineData = [ImageMachineModel]()
        for item in dataModel {
            let imageMachine = ImageMachineModel()
            imageMachine.machineId = item.machineId!
            imageMachine.machineName = item.machineName
            imageMachine.machineType = item.machineType
            imageMachine.machineQRCode = item.machineQRCode!
            imageMachineData?.append(imageMachine)
        }
        return imageMachineData
    }
    
    private func getSortedRequest(sortBy: String) -> NSFetchRequest<MachineData> {
        let request = MachineData.fetchRequest() as NSFetchRequest<MachineData>
        let sort = NSSortDescriptor(key: sortBy, ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
    
    func insertNewData(newData : ImageMachineModel) {
        let newImageMachine = MachineData(context: context)
        newImageMachine.machineName = newData.machineName
        newImageMachine.machineId = newData.machineId
        newImageMachine.machineType = newData.machineType
        newImageMachine.machineQRCode = newData.machineQRCode
        newImageMachine.lastMaintenanceDate = newData.machineLastMaintenanceDate
        do {
            try self.context.save()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let insertedData = selectData(sortBy: "machineName")
    }
}
