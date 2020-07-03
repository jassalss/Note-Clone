//
//  TableViewCell.swift
//  Notes Clone
//
//  Created by Simerpreet singh Jassal on 2020-07-02.
//  Copyright © 2020 Simerpreet singh Jassal. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    
    @IBOutlet var body: UILabel!
    
    @IBOutlet var radioBtn: UIImageView!
    
    let checked = UIImage(named: "checked-radio")
     let unchecked = UIImage(named: "unchecked-radio")
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configure(_ note: Note) {
        title.text = note.title
        if(note.body.count>20){
            body.text = note.dateAndTime + String(note.body.prefix(20))
        }else{
            body.text = note.dateAndTime + note.body
        }
    }
    public func isSelected(_ selected: Bool){
        setSelected(selected, animated: true)
        let image = selected ? checked : unchecked
        
        radioBtn.image = image
        
    }
    
}
