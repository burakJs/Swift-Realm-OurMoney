//
//  Payment.swift
//  OurMoney
//
//  Created by Burak İmdat on 30.09.2021.
//

import Foundation
import RealmSwift

class Payment: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var count: Int = -1
    let activity = LinkingObjects(fromType: Activity.self, property: "payments")
}
