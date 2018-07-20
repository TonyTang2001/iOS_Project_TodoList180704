//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/17.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
