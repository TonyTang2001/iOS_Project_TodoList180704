//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/27.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    let eventNameTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of Event"
        textField.backgroundColor = .gray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(eventNameTF)
        
        
//        eventNameTFSetup()
        
    }
    
    func eventNameTFSetup() {
        eventNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventNameTF.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        eventNameTF.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        eventNameTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }


}
