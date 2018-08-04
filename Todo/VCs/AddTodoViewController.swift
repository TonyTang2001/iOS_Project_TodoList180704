//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/27.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController, UITextFieldDelegate {

    var ContainerViewController : ContainerViewController!
    
    @IBOutlet weak var titleInputTF: UITextField!
    @IBOutlet weak var targetTimePicker: UIDatePicker!
    
    //    let eventNameTF: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Name of Event"
//        textField.backgroundColor = .gray
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor.lightGray
//        button.setTitle("Cancel", for: .normal)
//        button.setTitleColor(UIColor.black, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 6
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
//        return button
//    }()
//
//    @objc func cancel() {
//        dismiss(animated: true, completion: nil)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dismiss Keyboard after Tapping Elsewhere
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
        //Set titleInputTF as First Responder
        titleInputTF.delegate = self
        titleInputTF.becomeFirstResponder()
        
//        view.addSubview(eventNameTF)
//        view.addSubview(cancelButton)
//
//        eventNameTFSetup()
//        cancelButtonSetup()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        titleInputTF.resignFirstResponder()
    }
//    func eventNameTFSetup() {
//        eventNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        eventNameTF.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        eventNameTF.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
//        eventNameTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
//    }
//
//    func cancelButtonSetup() {
//        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
//    }
//
    
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        addNewTodo()
//        ContainerViewController.reloadData()
        dismiss(animated: true, completion: nil)
//        self.todoTableViewController.todoItems.append(newTodo)
        
        //Reload Data (Sorted by TargetTime)
//        self.todoTableViewController.loadData()
    }
    
    //MARK: - Add Todo
    //FIXME: TableView won't Reload After Creating a New Event
    func addNewTodo() {
        
        guard let title = titleInputTF.text else { return }
        //Prevent Space/Nil Input as title
        let trimmedInput = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedInput != "" {
            let newTodo = TodoItem(title: title, completed: false, createdAt: Date(), targetTime: targetTimePicker.date, itemIdentifier: UUID())
            
            newTodo.saveItem()
            
        } else {
            let addAlert = UIAlertController(title: "Cannot Create New Event", message: "Title of the Event Should Not Be Empty", preferredStyle: .alert)
            addAlert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(addAlert, animated: true, completion: nil)
        }
        
    }
        
}
