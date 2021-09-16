//
//  ImageMachineDetailViewController.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 06/08/21.
//

import UIKit

class ImageMachineDetailViewController: UIViewController {
    

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageMachineDetailView: ImageMachineDetailView!
    
    var imageMachineDetailModel : ImageMachineModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initImageMachineDetail()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initBarButton()
    }
    
    func initBarButton() {
        if imageMachineDetailModel.machineName == nil {
            hideSaveEditButton(editable: false)
            imageMachineDetailView.isEnableEditing(enableEditing: true)
        } else {
            hideSaveEditButton(editable: true)
            imageMachineDetailView.isEnableEditing(enableEditing: false)
        }
    }
    
    func initImageMachineDetail() {
        imageMachineDetailView.delegate = self
        imageMachineDetailView.presentationController = self
        if imageMachineDetailModel == nil {
            imageMachineDetailModel = imageMachineDetailView.initImageMachineModel()
        } else {
            imageMachineDetailView.imageMachineDetails = imageMachineDetailModel
        }
        
    }
    
    func hideSaveEditButton(editable:Bool) {
        editButton.isEnabled = editable
        saveButton.isHidden = editable
        if editable {
            editButton.tintColor = UIColor.darkGray
        } else {
            editButton.tintColor = UIColor.clear
        }
    }

    @IBAction func editingData(_ sender: Any) {
        hideSaveEditButton(editable: false)
        imageMachineDetailView.isEnableEditing(enableEditing: true)
    }
    
    @IBAction func savingData(_ sender: Any) {
        hideSaveEditButton(editable: true)
        if imageMachineDetailModel.machineName == nil {
            addingData()
        } else {
            updatingData()
        }
    }
}

extension ImageMachineDetailViewController : ImageMachineDetailActionDelegates {
    func updatingData() {
        if imageMachineDetailView.updateImageMachine() {
            imageMachineDetailModel = imageMachineDetailView.imageMachineDetails
            imageMachineDetailView.isEnableEditing(enableEditing: false)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            saveButton.isHidden = false
        }
    }
    
    func addingData() {
        if imageMachineDetailView.addImageMachine() {
            imageMachineDetailModel = imageMachineDetailView.imageMachineDetails
            imageMachineDetailView.isEnableEditing(enableEditing: false)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            saveButton.isHidden = false
        }
    }
}
