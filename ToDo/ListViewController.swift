//
//  ViewController.swift
//  ToDo
//
//  Created by John Gallaugher on 1/28/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, ListTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var listItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListItems()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureListItems() {
        
        listItems.append(ToDoItem(name: "Work on Swift Book", date: Date(), notes: "Hurry up! Swifters be waitin'!", completed: true))
        listItems.append(ToDoItem(name: "Exercise", date: Date(), notes: "Marathons want you!", completed: false))
        listItems.append(ToDoItem(name: "Play Guitar", date: Date(), notes: "Juke Box Hero!", completed: false))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ListDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.toDoItem = listItems[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ListDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            listItems[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(item: listItems.count, section: 0)
            listItems.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    func completedButtonToggled(sender: ListTableViewCell) {
        if let tappedIndexPath = tableView.indexPath(for: sender) {
            var listItem = listItems[tappedIndexPath.row]
            listItem.completed = !listItem.completed
            listItems[tappedIndexPath.row] = listItem
            tableView.reloadRows(at: [tappedIndexPath], with: .automatic)
        }
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self // check to see if I can move this to the cell's class
        cell.toDoItem = listItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = listItems[sourceIndexPath.row]
        listItems.remove(at: sourceIndexPath.row)
        listItems.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    
}
