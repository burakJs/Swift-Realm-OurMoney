//
//  EditPaymentVC.swift
//  OurMoney
//
//  Created by Burak İmdat on 5.10.2021.
//

import UIKit
import RealmSwift

class EditPaymentVC: UIViewController {

 
    var selectedPayment: Payment?
    var selectedActivity: Activity?
    let realm = try! Realm()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var lblTotalPayments: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
    }

    @IBAction func updatClicked(_ sender: UIButton) {
        
        if let selectedPayment = selectedPayment {
            do {
                try realm.write {
                    selectedPayment.name = txtName.text ?? "Not Entered"
                    selectedPayment.desc = txtDescription.text ?? "Not Entered"
                    selectedPayment.count = Int(txtAmount.text ?? "-1") ?? -1
                }
            } catch {
                print("Edit payment: \(error.localizedDescription)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setView() {
        txtName.text = selectedPayment?.name
        txtDescription.text = selectedPayment?.desc
        txtAmount.text = "\(selectedPayment!.count)"
        
        let activityText = NSMutableAttributedString(string: "Activity Name : ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
        activityText.append(NSAttributedString(string: "\(selectedActivity?.name ?? "")", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.black]))
        activityName.attributedText = activityText
        
        let totalPayments = selectedActivity?.payments.filter("name == %@",selectedPayment!.name).sum(ofProperty: "count") ?? 0
        let totalPaymentsText = NSMutableAttributedString(string: "Total Payments : ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
        totalPaymentsText.append(NSAttributedString(string: "\(totalPayments)₺", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.black]))
        lblTotalPayments.attributedText = totalPaymentsText
    }
}
