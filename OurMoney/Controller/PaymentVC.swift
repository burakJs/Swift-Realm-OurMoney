//
//  PaymentVC.swift
//  OurMoney
//
//  Created by Burak İmdat on 22.09.2021.
//

import UIKit
import RealmSwift

class PaymentVC: UITableViewController, UISearchBarDelegate {
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchbar: UISearchBar!
    var paymentList : Results<Payment>?
    
    var selectedActivity: Activity? {
        didSet {
            loadPayments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paymentList?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        
        if let payment = paymentList?[indexPath.row] {
            cell.textLabel?.text = "\(payment.name) - \(payment.count)₺"
        } else {
            cell.textLabel?.text = "Henüz eklenen bir ödeme bulunamadı"
        }
        return cell
    }
    
    @IBAction func btnAddPaymentClicked(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Payment", message: "Add Payment", preferredStyle: .alert)
        
        alertController.addTextField { txtName in
            txtName.placeholder = "Name of person who paid"
        }
        alertController.addTextField { txtDesc in
            txtDesc.placeholder = "Description of payment"
        }
        alertController.addTextField { txtPrice in
            txtPrice.placeholder = "Amount of payment"
            txtPrice.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            let txtName = alertController.textFields![0]
            let txtDesc = alertController.textFields![1]
            let txtPrice = alertController.textFields![2]
            
            if let selectedActivity = self.selectedActivity {
                do {
                    try self.realm.write {
                        let newPayment = Payment()
                        newPayment.name = txtName.text ?? "Not Entered"
                        newPayment.desc = txtDesc.text ?? "Not Entered"
                        newPayment.count = Int(txtPrice.text ?? "-1")!
                        selectedActivity.payments.append(newPayment)
                    }
                } catch {
                    print("Error in paymentlist: \(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
        alertController.addAction(add)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadPayments() {
        paymentList = selectedActivity?.payments.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editPaymentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPaymentSegue" {
            let destinationVC = segue.destination as! EditPaymentVC
            if let selectedIndex = tableView.indexPathForSelectedRow {
                if let selectedPayment = paymentList?[selectedIndex.row] {
                    destinationVC.selectedPayment = selectedPayment
                    destinationVC.selectedActivity = selectedActivity
                    destinationVC.title = "\(selectedPayment.name) Payment Information"
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedPayment = paymentList?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(selectedPayment)
                    }
                } catch {
                    print("Error in deleting payment : \(error.localizedDescription)")
                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        paymentList = paymentList?.filter("name CONTAINS[cd] %@", searchbar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text?.count == 0 {
            loadPayments()
            DispatchQueue.main.async {
                self.searchbar.resignFirstResponder()
            }
    
        }
    }
}
