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
    var notetitle: String?
    var hasNote: Note?
    var allNotes = [Note]()
    var textChnaged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitleBody.delegate = self

        if let existNote = hasNote {
            let title = existNote.title
               var body = existNote.body
                body = "\n" + body
                var myAttributes = [NSAttributedString.Key.font: UIFont(name: "helvetica-Bold", size: 40), NSAttributedString.Key.foregroundColor: UIColor.white,]
                let str = NSMutableAttributedString(string: title,attributes: myAttributes as [NSAttributedString.Key : Any] )
                myAttributes = [NSAttributedString.Key.font: UIFont(name: "helvetica-Bold", size: 18), NSAttributedString.Key.foregroundColor: UIColor.white,]
                let str2 = NSMutableAttributedString(string: body,attributes: myAttributes as [NSAttributedString.Key : Any] )
                str.append(str2)
                noteTitleBody.attributedText = str
            notetitle = existNote.title
            
        }else{
            noteTitleBody.font = UIFont(name: "helvetica-Bold", size: 40)
        }
    
    }
    func textViewDidChange(_ textView: UITextView) {
       textChnaged = true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            if count == 0 {
                noteTitleBody.font = UIFont(name: "helvetica", size: 18)
                let myAttributes = [NSAttributedString.Key.font: UIFont(name: "helvetica-Bold", size: 40), NSAttributedString.Key.foregroundColor: UIColor.white,]
                let str = NSMutableAttributedString(string: noteTitleBody.text,attributes: myAttributes as [NSAttributedString.Key : Any] )
                noteTitleBody.attributedText = str
                count += 1
                notetitle = str.string
            }
        }
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        var realBody = ""
        var title = ""
      if let body = noteTitleBody.text {
        if let goodTitle = notetitle{
            realBody = String(body.dropFirst(goodTitle.count)).trimmingCharacters(in: .whitespacesAndNewlines)
            

            title = goodTitle
        }else{
            title = noteTitleBody.text
        }
        let note = Note(title: title, body: realBody, selected: false)
        if textChnaged {
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd "
            let dateString = df.string(from: date)
            note.dateAndTime = dateString
        }
        if(title != ""){
            
            let defaults = UserDefaults.standard

            if let savedArray = defaults.object(forKey: "userCustomNotes") as? Data{
                let jsonDecoder = JSONDecoder()
                do{
                    allNotes = try jsonDecoder.decode([Note].self,from: savedArray)
                    if let index = allNotes.firstIndex(where: {$0.title==note.title}){
                        
                        allNotes.remove(at: index)
                    }
                    allNotes.append(note)
                    
                    save(defaults)
                } catch{
                    print("Failed to load people")
                }
            }
            else{
                allNotes.append(note)
                save(defaults)
                print("saved people")
        }
      }
    }
    }
    func save(_ defaults: UserDefaults){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(allNotes){
            defaults.set(savedData,forKey: "userCustomNotes")
        }else{
            print("Failed to save data")
        }
    }
}
