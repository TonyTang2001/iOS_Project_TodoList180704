//
//  ToDoTableViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/4.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoTableViewController: UITableViewController {
    
    var todoItems : [TodoItem]! {
        didSet{
            progressBar.setProgress(progress, animated: true)
        }
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progress : Float {
        if todoItems.count > 0 {
            return Float(todoItems.filter({$0.completed}).count) / Float(todoItems.count)
        } else {
            return 0
        }
    }
    
    func NaviItemTitleSetup() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        let timeString = dateFormatter.string(from: Date())
        self.navigationItem.title = timeString
    }
    
    //MARK: - Create Notif Func
    func createNotif(with notifTitle: String, and notifBody: String) {
        let content = UNMutableNotificationContent()
        content.title = notifTitle
        content.body = notifBody
        content.sound = UNNotificationSound.default
        content.threadIdentifier = notifTitle
        if #available(iOS 12.0, *) {
            content.summaryArgument = notifTitle
        } else {
            // Fallback on earlier versions
        }
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //MARK: Setup Pull to Refresh
    lazy var refresher: UIRefreshControl = {
        
        let refreshCtrl = UIRefreshControl()
        refreshCtrl.tintColor = UIColor(named: "mainDefaultLightGray")
        refreshCtrl.addTarget(self, action: #selector(loadDataR), for: .valueChanged)
        
        return refreshCtrl
    }()
    
    @objc func loadDataR(){
        loadData()
        print("Refresh Action to loadData()")
        
        let deadline = DispatchTime.now() + .milliseconds(600)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = refresher
        
        NaviItemTitleSetup()
        
        // SetUp Status Bar in UITableViewController
//        self.navigationController?.navigationBar.barStyle = .black
        
        loadData()
        
    }

    
    func loadData() {
        todoItems = [TodoItem]()
        todoItems = DataManager.loadAll(TodoItem.self).sorted(by: {
            $0.targetTime < $1.targetTime
        })
        tableView.reloadData()
        progressBar.setProgress(progress, animated: true)
    }
    
    //MARK: - Todo Manipulation
    //MARK: Add Todo
    func addNewTodo() {
        
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a Title", preferredStyle: .alert)
        
        addAlert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (UIAlertAction) in
            guard let title = addAlert.textFields?.first?.text else { return }
            //Prevent Space/Nil Input as title
            let trimmedInput = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedInput != "" {
                let newTodo = TodoItem(title: title, completed: false, createdAt: Date(), targetTime: Date(), itemIdentifier: UUID())
                
                newTodo.saveItem()
                self.todoItems.append(newTodo)
                
                //MARK: Create Notif
                //request Notification after Successfully Created Event
                //Notify User ONLY IF Out of App
                self.createNotif(with: title, and: title)
                
                //Reload Data (Sorted by TargetTime)
                self.loadData()
                
                //Load Newly Created Data Directly at Bottom of List
//                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
            } else {
                let addAlert = UIAlertController(title: "Cannot Create New Event", message: "Title of the Event Should Not Be Empty", preferredStyle: .alert)
                addAlert.addAction(UIKit.UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(addAlert, animated: true, completion: nil)
            }
        }))
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(addAlert, animated: true, completion: nil)
        
        

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        
        let todoItem = todoItems[indexPath.row]
        
        cell.todoLabel.text = todoItem.title
        
        //Transform Date! to String named timeString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.string(from: todoItem.targetTime)
        cell.targetTimeLabel.text = timeString
        
        if todoItem.completed {
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
        }
        
        return cell
    }
    
    //MARK: - Swipe Actions on Cell
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = UIColor(named: "mainDefaultRed")
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !(todoItems?[indexPath.row].completed)!{
            let complete = completeAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [complete])
        } else {
            let uncomplete = uncompleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [uncomplete])
        }
        
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "✓") { (action, view, completion) in
            self.completeTodoItem(indexPath)
            completion(true)
        }
        action.backgroundColor = UIColor(named: "mainDefaultGreen")
        return action
    }
    
    func uncompleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "⤫") { (action, view, completion) in
            self.uncompleteTodoItem(indexPath)
            completion(true)
        }
        action.backgroundColor = UIColor.black
        return action
    }

    //MARK: - Complete/UnComplete Todo
    //Complete
    func completeTodoItem(_ indexPath: IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.markAsCompleted()
        todoItems[indexPath.row] = todoItem
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.06, y: 1.0)
            }) { (success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
        
        //Haptic Feedback
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
    }
    
    //Uncomplete
    func uncompleteTodoItem(_ indexPath: IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.markAsUnCompleted()
        todoItems[indexPath.row] = todoItem
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            cell.todoLabel.attributedText = unStrikeThroughText(todoItem.title)
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.06, y: 1.0)

            }) { (success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
        
        //Haptic Feedback
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        
    }
    
    //Complete Effect
    func strikeThroughText (_ text : String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    //UnComplete Effect
    func unStrikeThroughText (_ text : String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
}
