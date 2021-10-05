//
//  Activity.swift
//  OurMoney
//
//  Created by Burak İmdat on 22.09.2021.
//

import Foundation
import RealmSwift

class Activity: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isChecked: Bool = false
    let payments = List<Payment>()
}
