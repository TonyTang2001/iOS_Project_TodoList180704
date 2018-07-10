//
//  ToDoTableViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/4.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SetUp Status Bar in UITableViewController
        self.navigationController?.navigationBar.barStyle = .black
        
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
    
    func addNewTodo() {
        
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a Title", preferredStyle: .alert)
        
        addAlert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (UIAlertAction) in
            
            guard let title = addAlert.textFields?.first?.text else { return }
            
            let newTodo = TodoItem(title: title, completed: false, createdAt: Date(), targetTime: Date(), itemIdentifier: UUID())
            
            newTodo.saveItem()
            self.todoItems.append(newTodo)
            
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true, completion: nil)
        
    }
    
    func showConnectivityAction() {
        
    }
    
    func completeTodoItem(_ indexPath: IndexPath) {
        var todoItem = todoItems[indexPath.row]
        todoItem.markAsCompleted()
        todoItems[indexPath.row] = todoItem
        
        if let cell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
            }) { (success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            }
        }
        
    }
    
    func didRequestShare(_ cell: ToDoTableViewCell) {
        
    }
    
    func strikeThroughText (_ text : String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action: UITableViewRowAction, indexPath: IndexPath) in
            self.todoItems[indexPath.row].deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = UIColor(named: "mainDefaultRed")
        
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeTodoItem(indexPath)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
