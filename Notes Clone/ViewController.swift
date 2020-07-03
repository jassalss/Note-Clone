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
//         let defaults = UserDefaults.standard
//         if let savedArray = defaults.object(forKey: "userCustomNotes") as? Data{
//             let jsonDecoder = JSONDecoder()
//             do{
//                 notes = try jsonDecoder.decode([Note].self,from: savedArray)
//
//             } catch{
//
//                 print("Failed to load people")
//             }
//         }

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
        print(note.body)
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
        notes[indexPath.row].selected.toggle()
        updateSelectedIndex(indexPath.row)
        createNewNote(notes[indexPath.row])
    }
    
    @objc func createNewNote(_ hasNote: Note){
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailViewController else {
            return
        }
        vc.hasNote = hasNote
        let backItem = UIBarButtonItem()
        backItem.title = "Notes"
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func deleteThem(){
        if editMode {
            editMode = false
            for note in notes {
                note.showTheRadioButton = false
            }
        }else{
            editMode = true
            for note in notes {
                note.showTheRadioButton = true
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

                   print("Failed to load people")
               }
           }
        tableView.reloadData()
        
    }
}

