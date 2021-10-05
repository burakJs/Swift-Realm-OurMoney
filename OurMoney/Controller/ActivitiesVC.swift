//
//  ActivitiesVC.swift
//  OurMoney
//
//  Created by Burak İmdat on 20.09.2021.
//

import UIKit
import RealmSwift

class ActivitiesVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var activityList: Results<Activity>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activityList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let result: Int = activityList?[indexPath.row].payments.sum(ofProperty: "count") ?? 0
        
        if let name = activityList?[indexPath.row].name {
            cell.textLabel?.text = "\(name) - \(result)₺"
        } else {
            cell.textLabel?.text = "Activity Not Found"
        }
        
        if activityList?[indexPath.row].isChecked ?? false {
            cell.backgroundColor = .darkGray
            cell.textLabel?.textColor = .white
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentListSegue" {
            let destinationVC = segue.destination as! PaymentVC
            
            if let selectedIndex = tableView.indexPathForSelectedRow {
                destinationVC.selectedActivity = activityList?[selectedIndex.row]
            }
        }
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
                self.saveData(activity: a1)
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(activity: Activity){
        do {
            try realm.write {
                realm.add(activity)
            }
        } catch {
            print("Realm Error: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        activityList = realm.objects(Activity.self)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if let selectedActivity = activityList?[indexPath.row] {
//                do {
//                    try realm.write {
//                        realm.delete(selectedActivity.payments)
//                        realm.delete(selectedActivity)
//                    }
//                } catch {
//                    print("Error in deleting activities : \(error.localizedDescription)")
//                }
//            }
//        }
//        tableView.reloadData()
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityList = activityList?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){_,_,_ in
            if let selectedActivity = self.activityList?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(selectedActivity.payments)
                        self.realm.delete(selectedActivity)
                    }
                } catch {
                    print("Error in deleting activities : \(error.localizedDescription)")
                }
            }
            tableView.reloadData()
        }
        
        let completeAction = UIContextualAction(style: .normal, title: "Completed"){_,_,_ in
            if let selectedActivity = self.activityList?[indexPath.row] {
                do {
                    try self.realm.write {
                        selectedActivity.isChecked = true
                    }
                } catch {
                    print("Error in deleting activities : \(error.localizedDescription)")
                }
            }
            tableView.reloadData()
        }
        
        completeAction.backgroundColor = #colorLiteral(red: 0, green: 0.7529165149, blue: 0.5437087417, alpha: 1)
        let swipe = UISwipeActionsConfiguration(actions: [completeAction,deleteAction])
        return swipe
    }
}
