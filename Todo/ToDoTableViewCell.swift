//
//  ToDoTableViewCell.swift
//  Todo
//
//  Created by 唐子轩 on 2018/7/4.
//  Copyright © 2018 TonyTang. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func completeTodo(_ sender: Any) {
    }
    
    @IBAction func deleteTodo(_ sender: Any) {
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
