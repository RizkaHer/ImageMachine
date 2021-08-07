//
//  ImageMachineDetailView.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 06/08/21.
//

import UIKit

protocol NewImageMachineProtocols {
    var createdDateString:String{get}
    func generateId()
    func generateQRCodeNo()
}

protocol ImageMachineDetailActionDelegates {
    func addingData()
    func updatingData()
}

struct MachineImages {
    var machineImage : [UIImage]
}

class ImageMachineDetailView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var machineId: UILabel!
    @IBOutlet weak var machineName: UITextField!
    @IBOutlet weak var machineType: UITextField!
    @IBOutlet weak var machineQRCode: UILabel!
    @IBOutlet weak var machineLastMaintenanceDate: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    
    private var machineImages : [UIImage]!
//    private let maintenanceDatePicker = UIDatePicker()
    var imageMachineDetails : ImageMachineModel!
    weak var presentationController: UIViewController?
    
    private var createdDate : Date!
    var delegate : ImageMachineDetailActionDelegates?
    private var enableEditing : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ImageMachineDetailView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        if  imageMachineDetails == nil {
            imageMachineDetails = ImageMachineModel()
        }
        machineId.text = imageMachineDetails.machineId
        machineQRCode.text = imageMachineDetails.machineQRCode
    }
    
    func isEnableEditing(enableEditing: Bool) {
        self.enableEditing = enableEditing
        machineName.isUserInteractionEnabled = enableEditing
        machineType.isUserInteractionEnabled = enableEditing
        machineLastMaintenanceDate.isUserInteractionEnabled = enableEditing
        addImageButton.isUserInteractionEnabled = enableEditing
        
        if enableEditing {
            machineName.becomeFirstResponder()
            machineType.becomeFirstResponder()
            machineLastMaintenanceDate.becomeFirstResponder()
        }
    }
    
    func addImageMachine()-> Bool {
        var maintenanceDate : Date!
        if let dateString = machineLastMaintenanceDate.text {
            maintenanceDate = dateString.toDate()
        }
        
        let validateResult = isInputValid()
        if validateResult.0 {
            if maintenanceDate != nil {
                imageMachineDetails.machineLastMaintenanceDate = maintenanceDate
            }
            
            if machineImages != nil {
                imageMachineDetails.machineImages = machineImages
            }
            imageMachineDetails.machineName = machineName.text!
            imageMachineDetails.machineType = machineType.text!
            imageMachineDetails.machineLastMaintenanceDate = maintenanceDate
            imageMachineDetails.machineImages = machineImages
            return true
        } else {
            showAlert(message: validateResult.1!)
            return false
        }
        
    }
    
    func updateImageMachine() -> Bool {
        var maintenanceDate : Date!
        if let dateString = machineLastMaintenanceDate.text {
            maintenanceDate = dateString.toDate()
        }
        
        let validateResult = isInputValid()
        if validateResult.0 {
            if machineLastMaintenanceDate != nil {
                imageMachineDetails.machineLastMaintenanceDate = maintenanceDate
            }
            
            if machineImages != nil {
                imageMachineDetails.machineImages = machineImages
            }
            imageMachineDetails.machineName = machineName.text!
            imageMachineDetails.machineType = machineType.text!
            imageMachineDetails.machineLastMaintenanceDate = maintenanceDate
            imageMachineDetails.machineImages = machineImages
            return true
        } else {
            showAlert(message: validateResult.1!)
            return false
        }
    }
    
    func isInputValid() -> (Bool, String?) {
        if machineName.text == nil {
            return (false, "nvalid Machine's Name")
        } else if machineName.text!.count < 3 {
            return (false, "Invalid Machine's Name")
        } else if machineType.text == nil {
            return (false, "nvalid Machine's Type")
        } else if machineType.text!.count < 3 {
            return (false, "Invalid Machine's Type")
        } else {
            return (true, nil)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "SAVE FAILED", message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.presentationController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        //open gallery
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from:self)
        return date
    }
}

extension ImageMachineDetailView {
//    func showDatePicker() {
//        maintenanceDatePicker.datePickerMode = .date
//        machineLastMaintenanceDate.inputView = maintenanceDatePicker
//
//        let toolbar = UIToolbar();
//           toolbar.sizeToFit()
//
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: Selector(("doneDatePicker")))
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: Selector(("cancelInput")))
//        toolbar.setItems([doneButton, cancelButton], animated: false)
//        machineLastMaintenanceDate.inputAccessoryView = toolbar
//
//    }
//
//    private func doneDatePicker() {
//        let formatter = DateFormatter()
//           formatter.dateFormat = "dd/MM/yyyy"
//        machineLastMaintenanceDate.text = formatter.string(from: maintenanceDatePicker.date)
//        self.endEditing(true)
//    }
//
//    private func cancelInput() {
//        self.endEditing(true)
//    }
}
