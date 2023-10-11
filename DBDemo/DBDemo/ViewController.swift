//
//  ViewController.swift
//  DBDemo
//
//  Created by Bilal Hassan on 23/5/19.
//  Copyright © 2019 Bilal Hassan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var personTable: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var db:DBHelper = DBHelper()
    
    var persons:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        personTable.delegate = self
        personTable.dataSource = self
        
        db.insert(name: "Karan", exp: "1.7")
        db.insert(name: "saad", exp: "0.4" )
        db.insert(name: "chintan", exp: "0.4")
        db.insert(name: "aditya", exp: "0.4")
        
//        db.deleteByID(id: 3)
//        db.deleteByID(id: 5)
        
        persons = db.read()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = "Name: " + persons[indexPath.row].name + ", " + "Experience: " + String(persons[indexPath.row].exp)
        
        return cell
    }
    
    
    
}

