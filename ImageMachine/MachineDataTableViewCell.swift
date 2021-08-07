//
//  MachineDataTableViewCell.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 06/08/21.
//

import UIKit

class MachineDataTableViewCell: UITableViewCell {
    @IBOutlet weak var machineName: UILabel!
    @IBOutlet weak var machineType: UILabel!
    
    static let reusabelIdentifier = "machineDataCell"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(machineData: MachineData) {
        machineName.text = machineData.machineName
        machineType.text = machineData.machineType
    }
    
}
