//
//  ConsoleScreen.swift
//  TechmasterSwiftApp
//


import UIKit

class ConsoleScreen: UIViewController {
    weak var console:UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let console = UITextView(frame: self.view.bounds)
        console.backgroundColor = UIColor.blackColor()
        console.textColor = UIColor.greenColor()
        console.font = UIFont(name: "Courier", size: 16)
        console.editable = false
        self.view.addSubview(console)
        self.console = console
    }
    
    func write(string: String){
        let temp = self.console.text
        self.console.text = temp.stringByAppendingString(string)
    }
    func writeln (string: String){
        let temp = self.console.text
        self.console.text = temp.stringByAppendingFormat("%@%@", string, "\n")
    }
}
