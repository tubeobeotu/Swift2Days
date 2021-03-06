//
//  AddUpdateStudentVC.swift
//  DemoTable
//
//  Created by cuong minh on 11/18/16.
//  Copyright (c) 2016 Techmaster. All rights reserved.
//

import UIKit
protocol StudentListVCDelegate
{
    func addStudent(student: Student)
}
class AddUpdateStudentVC: UIViewController, UITextFieldDelegate {
    var delegate: StudentListVCDelegate!
    private var txtfullName: UITextField!
    private var sliderScore: UISlider!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.whiteColor()
        self.title = "Add/Update Student"
        self.edgesForExtendedLayout = UIRectEdge()
        txtfullName = UITextField()
        txtfullName.translatesAutoresizingMaskIntoConstraints = false
        txtfullName.delegate = self
        txtfullName.placeholder = "Please enter full name of student"
        txtfullName.borderStyle = UITextBorderStyle.Line
        let requiredImage = UIImage(named: "required.png")
        let rightView = UIImageView(image: requiredImage)
        rightView.bounds = CGRectInset(CGRect(origin: CGPoint.zero, size: requiredImage!.size), -3, -3)
        rightView.contentMode = UIViewContentMode.Left
        txtfullName.rightView = rightView
        
        txtfullName.rightViewMode = UITextFieldViewMode.Always
        view.addSubview(txtfullName)
        
        sliderScore = UISlider()
        sliderScore.minimumValue = 0
        sliderScore.maximumValue = 10
        sliderScore.value = 0
        sliderScore.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sliderScore)
        
        let views = ["view": view, "txfullName": txtfullName, "sliderScore": sliderScore]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[txfullName(30)]-40-[sliderScore(30)]-(>=20)-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[txfullName]-20-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[sliderScore]-20-|", options: [], metrics: nil, views: views))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "save")!, target: self, action: #selector(AddUpdateStudentVC.onSave))
    }
  
    func onSave() {
        delegate.addStudent(Student(name: txtfullName.text!, score: Double(sliderScore.value), liked: true))
        self.navigationController!.popViewControllerAnimated(true)
        
    }
}
