//
//  ViewController.swift
//  Notes Clone
//
//  Created by Simerpreet singh Jassal on 2020-06-30.
//  Copyright © 2020 Simerpreet singh Jassal. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var selectedNote: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var notes = [Note]()
    var editMode = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let myLabl = UILabel()
        myLabl.text = "Notes"
        myLabl.tintColor = .systemYellow
        myLabl.font = myLabl.font.withSize(30)
        myLabl.textAlignment = .left
        self.navigationItem.titleView = myLabl
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deleteThem))
        navigationController?.isToolbarHidden = false
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action: nil)
        let newNote = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewNote))
        navigationController?.toolbar.tintColor = .systemYellow
        toolbarItems = [spacer,newNote]
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"myNote")
        
    }
    private func updateSelectedIndex(_ index: Int) {
        selectedNote = index
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myNote", for: indexPath) as? TableViewCell else {
            fatalError("Cell not found")
        }
        let note = notes[indexPath.row]
        cell.selectionStyle = .none
       
        
        let seleted = note.selected
        cell.configure(note)
        cell.isSelected(seleted)
        if(seleted){
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        }else{
            cell.backgroundColor = .clear
        }
        cell.radioBtn.isHidden = note.showTheRadioButton
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curr = indexPath.row
        notes[curr].selected.toggle()
        updateSelectedIndex(curr)
        if (editMode){
            if notes.count >= curr {
                openExistingNote(passMeNote: notes[curr])
            }
        }
    }
    
     func openExistingNote(passMeNote : Note){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController else {
            return
        }
        
        vc.hasNote = passMeNote
        
        let backItem = UIBarButtonItem()
        backItem.title = "Notes"
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func createNewNote(){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController else {
            return
        }
        
        
        let backItem = UIBarButtonItem()
        backItem.title = "Notes"
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func deleteTheNotes(){
        var count = 0
        for (note) in notes{
            if note.selected {
                notes.remove(at: count)
                continue
            }
            count += 1
        }
        tableView.reloadData()
        save()
    }
    @objc func deleteThem(){
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action: nil)
        if editMode {
            editMode = false
            for note in notes {
                note.showTheRadioButton = false
                note.selected = false
                let deleteNotes = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTheNotes))
                toolbarItems = [spacer,deleteNotes]
            }
        }else{
            editMode = true
            for note in notes {
                note.showTheRadioButton = true
                note.selected = false
                 let newNote = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewNote))
                toolbarItems = [spacer,newNote]
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
           if let savedArray = defaults.object(forKey: "userCustomNotes") as? Data{
               let jsonDecoder = JSONDecoder()
               do{
                   notes = try jsonDecoder.decode([Note].self,from: savedArray)

               } catch{
                   print("Failed to load Old notes")
               }
           }
        tableView.reloadData()
        
    }
    func save(){
        let jsonEncoder = JSONEncoder()
         let defaults = UserDefaults.standard
        if let savedData = try? jsonEncoder.encode(notes){
            defaults.set(savedData,forKey: "userCustomNotes")
        }else{
            print("Failed to save data")
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
        
    }
}

