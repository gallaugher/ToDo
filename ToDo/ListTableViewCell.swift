//
//  ListTableViewCell.swift
//  ToDo
//
//  Created by John Gallaugher on 1/29/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func completedButtonToggled(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var toDoItemLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!

    
    weak var delegate: ListTableViewCellDelegate!
    var toDoItem: ToDoItem!
    {
        didSet {
            toDoItemLabel.text = toDoItem.name
            completedButton.isSelected = toDoItem.completed
        }
    }
    
    @IBAction func completedButtonToggled(_ sender: UIButton) {
        delegate.completedButtonToggled(sender: self)
    }
}
