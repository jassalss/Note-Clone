//
//  Note.swift
//  Notes Clone
//
//  Created by Simerpreet singh Jassal on 2020-07-02.
//  Copyright © 2020 Simerpreet singh Jassal. All rights reserved.
//

import UIKit

class Note: Codable {
    
    var title : String
    var body : String
    var selected : Bool
    var showTheRadioButton: Bool
    init(title: String, body: String,selected: Bool) {
        self.title = title
        self.body = body
        self.selected = selected
        self.showTheRadioButton = true
    }
}
