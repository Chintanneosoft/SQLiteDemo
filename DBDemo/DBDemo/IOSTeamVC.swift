//
//  ViewController.swift
//  DBDemo
//
//  Created by Bilal Hassan on 23/5/19.
//  Copyright © 2019 Bilal Hassan. All rights reserved.
//

import UIKit
class IOSTeamVC: UIViewController{
    
    @IBOutlet weak var personTable: UITableView!
    
    var db:DBManager = DBManager()
    var persons:[Person] = []
    var updated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUpUI()
    }
    
    
    func setUpUI(){
        persons = db.read()
        navigationController?.isNavigationBarHidden = false
    }
    
    func setTableView(){
        personTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        personTable.delegate = self
        personTable.dataSource = self
    }
    
    func saveData(person: Person?){
        let alertController = UIAlertController(title: "Enter Information", message: "", preferredStyle: .alert)
        alertController.addTextField { (name) in
            name.placeholder = "Developer Name "
            name.text = person?.name ?? ""
        }
        alertController.addTextField { (experience) in
            experience.placeholder = "Experience"
            experience.text = person?.exp ?? ""
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let devName = alertController.textFields?[0].text,
               let devExp = alertController.textFields?[1].text {
                if person != nil{
                    self.db.updateByID(id: person?.id ?? 0, name: devName, exp: devExp)
                } else {
                    self.db.insert(name: devName, exp: devExp)
                }
                self.persons = self.db.read()
                self.personTable.reloadData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func plusBarItemTapped(_ sender: UIBarButtonItem) {
        saveData(person: nil)
    }
}

extension IOSTeamVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return persons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "Name: " + persons[indexPath.row].name + ", " + "Experience: " + String(persons[indexPath.row].exp)
        return cell
    }
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let person = persons[indexPath.row]
    //            db.deleteByID(id: person.id)
    //            persons = db.read()
    //            personTable.reloadData()
    //        }
    //    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler)  in
            let person = self.persons[indexPath.row]
            self.saveData(person: person)
            self.persons = self.db.read()
            self.personTable.reloadData()
            completionHandler(true)
        }
        update.backgroundColor = .magenta
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let person = self.persons[indexPath.row]
            self.db.deleteByID(id: person.id)
            self.persons = self.db.read()
            self.personTable.reloadData()
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
    
}

