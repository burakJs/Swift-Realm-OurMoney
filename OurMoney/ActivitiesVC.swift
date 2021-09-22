//
//  ActivitiesVC.swift
//  OurMoney
//
//  Created by Burak İmdat on 20.09.2021.
//

import UIKit

class ActivitiesVC: UITableViewController {
    
    var datas = UserDefaults.standard
    var activityList: [Activity] = [Activity]()
    static let plistFileName: String = "Activities.plist"
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(plistFileName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let a1 = Activity()
        a1.name = "Ev"
        a1.isChecked = true
        activityList.append(a1)
        let a2 = Activity()
        a2.name = "Kapadokya Gezisi"
        activityList.append(a2)
        let a3 = Activity()
        a3.name = "Okul Arkadaşları"
        activityList.append(a3)
        let a4 = Activity()
        a4.name = "Istanbul Gezisi"
        activityList.append(a4)
        
//        if let activities = datas.array(forKey: "activities") as? [Activity] {
//            activityList = activities
//        }
        readData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activityList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = activityList[indexPath.row].name
        
        if activityList[indexPath.row].isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = tableView.cellForRow(at: indexPath)
//        selectedCell?.accessoryType = (selectedCell?.accessoryType == .checkmark) ? .none : .checkmark
//        activityList[indexPath.row].isChecked = !activityList[indexPath.row].isChecked
//        tableView.reloadData()
        performSegue(withIdentifier: "paymentListSegue", sender: self)

    }
    
    
    @IBAction func addActivityClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Activity", message: "You can add activity with these informations", preferredStyle: .alert)
        alert.addTextField { txtActivityName in
            txtActivityName.placeholder = "Activity Name"
        }
        
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            let activityName = alert.textFields![0]
            
            if !activityName.text!.isEmpty {
                let a1 = Activity()
                a1.name = activityName.text!
                self.activityList.append(a1)
//                self.datas.set(self.activityList, forKey: Keys.ActivityKey.rawValue)
                self.saveData()
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            let data = try PropertyListEncoder().encode(self.activityList)
            try data.write(to: self.filePath)
        } catch {
            print("\(error)")
        }
    }
    
    func readData() {
        if let data = try? Data(contentsOf: filePath) {
            do {
                activityList = try PropertyListDecoder().decode([Activity].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
