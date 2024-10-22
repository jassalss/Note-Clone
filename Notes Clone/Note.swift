//
//  Note.swift
//  Notes Clone
//
//  Created by Simerpreet singh Jassal on 2020-07-02.
//  Copyright © 2020 Simerpreet singh Jassal. All rights reserved.
//

import UIKit

class Note: NSObject,Codable {
    
    var title : String
    var body : String
    var selected : Bool
    var showTheRadioButton: Bool
    var dateAndTime : String
    init(title: String, body: String,selected: Bool) {
        self.title = title
        self.body = body
        self.selected = selected
        self.showTheRadioButton = true
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd "
        let dateString = df.string(from: date)
        dateAndTime = dateString
    }
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.title == rhs.title
    }
}
