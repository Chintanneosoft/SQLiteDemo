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
    
    @IBAction func plusBarItemTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Enter Information", message: "", preferredStyle: .alert)
        alertController.addTextField { (name) in
            name.placeholder = "Developer Name "
        }
        alertController.addTextField { (experience) in
            experience.placeholder = "Experience"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let devName = alertController.textFields?[0].text,
               let devExp = alertController.textFields?[1].text {
                self.db.insert(name: devName, exp: devExp)
                self.persons = self.db.read()
                self.personTable.reloadData()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = persons[indexPath.row]
            db.deleteByID(id: person.id)
            persons = db.read()
            personTable.reloadData()
        }
    }
}

