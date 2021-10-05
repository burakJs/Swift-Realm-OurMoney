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
    let realm = try! Realm()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
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
    }
}
