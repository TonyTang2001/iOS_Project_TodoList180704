//
//  ToDoTableViewCell.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/4.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

protocol TodoCellDelegate {
    func didRequestDelete (_ cell: ToDoTableViewCell)
    func didRequestComplete (_ cell: ToDoTableViewCell)
}

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    
    var delegate : TodoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func completeTodo(_ sender: Any) {
        
        if let delegateObj = self.delegate {
            delegateObj.didRequestComplete(self)
        }
    }
    
    @IBAction func deleteTodo(_ sender: Any) {
        if let delegateObj = self.delegate {
            delegateObj.didRequestDelete(self)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
