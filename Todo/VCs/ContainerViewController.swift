//
//  ContainerViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/10.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    var todoTableViewController : ToDoTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.layer.cornerRadius = addButton.frame.size.width / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoVC" {
            todoTableViewController = (segue.destination as! UINavigationController).children.first as? ToDoTableViewController
            
        }
    }
    
    @IBAction func addNewTodoItem(_ sender: Any) {
        todoTableViewController.addNewTodo()
    }
    
    //Status Bar Style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func reloadData() {
        todoTableViewController.loadData()
    }
    

}
