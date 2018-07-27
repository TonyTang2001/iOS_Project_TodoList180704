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
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.lightGray
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(eventNameTF)
        view.addSubview(cancelButton)
        
        eventNameTFSetup()
        cancelButtonSetup()
    }
    
    func eventNameTFSetup() {
        eventNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventNameTF.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        eventNameTF.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        eventNameTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func cancelButtonSetup() {
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
    }

}
