//
//  DetailViewController.swift
//  Notes Clone
//
//  Created by Simerpreet singh Jassal on 2020-07-01.
//  Copyright © 2020 Simerpreet singh Jassal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var noteTitleBody: UITextView!
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitleBody.delegate = self
        noteTitleBody.font = UIFont(name: "helvetica-Bold", size: 40)
    
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            if count == 0 {
                noteTitleBody.font = UIFont(name: "helvetica", size: 18)
                let myAttributes = [NSAttributedString.Key.font: UIFont(name: "helvetica-Bold", size: 40), NSAttributedString.Key.foregroundColor: UIColor.white,]
                let str = NSMutableAttributedString(string: noteTitleBody.text,attributes: myAttributes as [NSAttributedString.Key : Any] )
                noteTitleBody.attributedText = str
                count += 1
            }
        }
        return true
    }
}
