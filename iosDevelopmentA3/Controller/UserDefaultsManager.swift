//
//  UserDefaultsManager.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation

class UserDefaultManager {

    static let shared = UserDefaultManager()
    let defaults = UserDefaults(suiteName: "Assignment3Data")

    

    func removeAllData() {
        defaults!.removePersistentDomain(forName: "Assignment3Data")
        defaults!.synchronize()
    }
}
