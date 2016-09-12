//
//  StudentListVC.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

import UIKit

class StudentListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var students = [Student]()

    private var tableView: UITableView!
    private var toolBar: UIToolbar!
    private var addUpdateStudentVC : AddUpdateStudentVC!

    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView(frame: CGRect.null, style: UITableViewStyle.Plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let fixWidthSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixWidthSpace.width = 30
        let addButton = UIBarButtonItem(image: UIImage(named: "add")!, target: self, action: "onAdd")
        let saveButton = UIBarButtonItem(image: UIImage(named: "save")!, target: self, action: "onSave")
        toolBar.items = [spacer, addButton, fixWidthSpace, saveButton, spacer]
        view.addSubview(toolBar)
        
        let views = ["view": view, "tableView": tableView, "toolBar": toolBar]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView][toolBar(40)]-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolBar]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    }
    
    func initData() {
        students.append(Student(name: "James Rock", score: 8.0))
        students.append(Student(name: "Diana Rose", score: 1.0))
    }
    override func viewDidLoad() {
       super.viewDidLoad()
       initData()
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell!
        if let dequeCell = tableView.dequeueReusableCellWithIdentifier("#") as? UITableViewCell {
            cell = dequeCell
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "#")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let student = students[indexPath.row] as Student
        cell.textLabel?.text = student.fullName
        
        return cell
        
        
    }
    //MARK: UITableViewDelegate
    //MARK: Handle tool bar button actions
    func onAdd() {
        if addUpdateStudentVC == nil {
            addUpdateStudentVC = AddUpdateStudentVC()
        }
        self.navigationController?.pushViewController(addUpdateStudentVC, animated: true)
    }

}
