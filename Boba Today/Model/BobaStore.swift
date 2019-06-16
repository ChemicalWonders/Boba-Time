//
//  BobaStore.swift
//  Boba Today
//
//  Created by Kevin Chan on 6/15/19.
//  Copyright © 2019 Kevin Chan. All rights reserved.
//

import Foundation
class BobaStore {
    var storeName: String = "";
    var imageURL: String = "";
    var rating: Int = 0;
    var location: String = "";
    var phone: String = "";
    var didUpdate: Bool = false;
    
    func printStoreInfo() {
        print("Store Name = \(storeName), imageURL = \(imageURL), Rating = \(rating), location = \(location), phone = \(phone) ")
    }
}
