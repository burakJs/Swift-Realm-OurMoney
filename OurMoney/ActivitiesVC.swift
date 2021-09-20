//
//  ActivitiesVC.swift
//  OurMoney
//
//  Created by Burak İmdat on 20.09.2021.
//

import UIKit

class ActivitiesVC: UITableViewController {
    
    var activities = ["Ev","Kapadokya Gezisi","Okul Arkadaşları","Istanbul Gezisi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = activities[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType = (selectedCell?.accessoryType == .checkmark) ? .none : .checkmark
    }
    
    
    @IBAction func addActivityClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Activity", message: "You can add activity with these informations", preferredStyle: .alert)
        alert.addTextField { txtActivityName in
            txtActivityName.placeholder = "Activity Name"
        }
        
        
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            let activityName = alert.textFields![0]
            print(activityName.text)
            if !activityName.text!.isEmpty {
                self.activities.append(activityName.text!)
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
        print(activities)
    }
}
