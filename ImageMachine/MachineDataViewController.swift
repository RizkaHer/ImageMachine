//
//  MachineDataViewController.swift
//  ImageMachine
//
//  Created by Rizka Heristanti on 04/08/21.
//

import UIKit
import CoreData

protocol MachineDataProtocols {
    func fetchMachineData()
    func deleteMachineData(deletedData: [MachineData])
    func updateView()
}


class MachineDataViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var machineDataNotFound: UILabel!
    
    @IBOutlet weak var sortingMenuView: UIView!
    @IBOutlet weak var sortOptionButton: UIButton!
    
    @IBOutlet weak var sortingView: UIView!
    @IBOutlet weak var nameSortButton: UIButton!
    @IBOutlet weak var typeSortButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    var machineData : [MachineData]?
    var isDefaultSort : Bool = true
    var imageMachineDataModel : ImageMachineDataModel?
    var showedData : [ImageMachineModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imageMachineDataModel = ImageMachineDataModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      fetchMachineData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    func addPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchMachineData()
    }
    
    @IBAction func sortMachineDataBy(_ sender: Any) {
        isHiddenSortOptionView(isHiding: false)
    }
    
    @IBAction func sortingByName(_ sender: Any) {
        isDefaultSort = true
        updateFilteredView()
    }
    
    @IBAction func sortingByType(_ sender: Any) {
        isDefaultSort = false
        updateFilteredView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != sortingView {
            sortingView.isHidden = true
        }
    }
    
    private func updateFilteredView() {
        getShowedData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getShowedData() {
        showedData = [ImageMachineModel]()
        if isDefaultSort {
            showedData = showedData!.sorted { $0.machineName! < $1.machineName!}
        } else {
            showedData = showedData!.sorted { $0.machineType! < $1.machineType!}
        }
    }
}

extension MachineDataViewController: MachineDataProtocols {
    
    func fetchMachineData() {
        var key = "machineName"
        if !isDefaultSort {
            key = "machineType"
        }
        showedData = imageMachineDataModel?.selectData(sortBy: key)
    }
    
    func deleteMachineData(deletedData: [MachineData]) {
        print("delete")
    }
    
    func updateView() {
        isHiddenSortOptionView(isHiding: true)
        if showedData != nil && showedData!.count > 0 {
            tableView.isHidden = false
            machineDataNotFound.isHidden = true
            isHiddenSortMenu(isHiding: false)
        } else {
            tableView.isHidden = true
            machineDataNotFound.isHidden = false
            isHiddenSortMenu(isHiding: true)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func isHiddenSortOptionView(isHiding: Bool) {
        sortingView.isHidden = isHiding
        nameSortButton.isHidden = isHiding
        typeSortButton.isHidden = isHiding
    }
    
    private func isHiddenSortMenu(isHiding: Bool) {
        sortingMenuView.isHidden = isHiding
        sortOptionButton.isHidden = isHiding
    }
}

extension MachineDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showedData != nil && showedData!.count > 0 {
            return showedData!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "machineDataCell", for: indexPath) as! MachineDataTableViewCell
        if let currentMachineData = showedData {
            let currentData = currentMachineData[indexPath.row]
            cell.updateCell(machineData: currentData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = showedData?[indexPath.row]
        let destinationVC = ImageMachineDetailViewController()
        destinationVC.imageMachineDetailModel = selectedData
        destinationVC.performSegue(withIdentifier: "showImageMachineDetail", sender: self)
    }
}
