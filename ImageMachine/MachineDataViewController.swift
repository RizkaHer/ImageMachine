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
    var showedData : [MachineData]?
    var isDefaultSort : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        showedData = [MachineData]()
        if isDefaultSort {
            showedData = machineData!.sorted { $0.machineName! < $1.machineName!}
        } else {
            showedData = machineData!.sorted { $0.machineType! < $1.machineType!}
        }
    }
}

extension MachineDataViewController: MachineDataProtocols {
    
    func fetchMachineData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            machineData = try managedContext.fetch(getSortedRequest())
            updateView()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            updateView()
        }
    }
    
    private func getSortedRequest() -> NSFetchRequest<MachineData> {
        let request = MachineData.fetchRequest() as NSFetchRequest<MachineData>
        
        var key = "machineName"
        if !isDefaultSort {
            key = "machineType"
        }
            
        let sort = NSSortDescriptor(key: key, ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
    
    func deleteMachineData(deletedData: [MachineData]) {
        print("delete")
    }
    
    func updateView() {
        isHiddenSortOptionView(isHiding: true)
        if machineData != nil && machineData!.count > 0 {
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
        let currentData = showedData![indexPath.row]
        cell.updateCell(machineData: currentData)
        return cell
    }
}
