//
//  IndexTable.swift
//  DemoTable
//
//  Created by cuong minh on 11/4/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit

class IndexTable: UITableViewController {

    var animals:[String: [String]]!
    var animalSectionTitles: [String]!
//    var animalIndexTitles: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
    }
    
    func initData() {
        animals = ["B" : ["Bear", "Black Swan", "Buffalo"],
            "C" : ["Camel", "Cockatoo"],
            "D" : ["Dog", "Donkey"],
            "E" : ["Emu"],
            "G" : ["Giraffe", "Greater Rhea"],
            "H" : ["Hippopotamus", "Horse"],
            "K" : ["Koala"],
            "L" : ["Lion", "Llama"],
            "M" : ["Manatus", "Meerkat"],
            "P" : ["Panda", "Peacock", "Pig", "Platypus", "Polar Bear"],
            "R" : ["Rhinoceros"],
            "S" : ["Seagull"],
            "T" : ["Tasmania Devil"],
            "W" : ["Whale", "Whale Shark", "Wombat"]]

        
        let temps = animals.keys

        animalSectionTitles = temps.sort({ $0 < $1
            
        })
        
//        animalIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    func getImageFileName(animal: String) -> String {
        var imageFileName = animal.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "_")
        imageFileName += ".jpg"
        return imageFileName
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return animalSectionTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionTitle = animalSectionTitles[section];
        let sectionAnimals = animals[sectionTitle];
        return sectionAnimals!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return animalSectionTitles[section]
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return animalSectionTitles
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("id", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let sectionTitle = animalSectionTitles[indexPath.section]
        let sectionAnimals = animals[sectionTitle]!
        let animal = sectionAnimals[indexPath.row]
        cell.textLabel?.text = animal
        cell.imageView?.image = UIImage(named: getImageFileName(animal))
        return cell
        
    }
}
