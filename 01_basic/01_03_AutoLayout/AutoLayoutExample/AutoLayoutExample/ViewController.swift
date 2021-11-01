//
//  ViewController.swift
//  AutoLayoutExample
//
//  Created by Jeonggi Hong on 2021/10/28.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapChangeColorButton(_ sender: UIButton) {
        self.colorView.backgroundColor = UIColor.blue
        print("색상 변경 버튼이 클릭되었음")
    }
    
}

