//
//  AddTodoViewController.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/17.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {
 
    //MARK: Outlets
    @IBOutlet weak var eventNameTF: UITextView!
    @IBOutlet weak var segmentedCtrl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardShow(with:)),
            name: .UIKeyboardWillShow,
            object: nil)
        eventNameTF.becomeFirstResponder()
    }
    
    //MARK: Actions
    
    @objc func keyboardShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true)
        eventNameTF.resignFirstResponder()
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

extension AddTodoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if doneButton.isHidden {
            
            eventNameTF.text.removeAll()
            eventNameTF.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}


