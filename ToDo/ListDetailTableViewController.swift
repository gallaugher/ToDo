//
//  ListDetailTableViewController.swift
//  ToDo
//
//  Created by John Gallaugher on 1/28/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import UIKit
import UserNotifications

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ListDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notesView: UITextView!
    
    var toDoItem: ToDoItem!
    
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    
    let normalCellHeight: CGFloat = 44
    let largeCellHeight: CGFloat = 200
    var datePickerHidden = true
    
    let manager = LocalNotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", completed: false)
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameField.text = toDoItem.name
        notesView.text = toDoItem.notes
        datePicker.date = toDoItem.date
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
    }
    
    func updateFromUserInterface() {
        toDoItem.name = nameField.text!
        toDoItem.notes = notesView.text
        toDoItem.date = datePicker.date
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateFromUserInterface()
        scheduleLocalNotification()
    }
    
    func scheduleLocalNotification() {
        // when to show it
        let date = datePicker.date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        // If there's already a local notification, keep the current ID, but update the time
        // otherwise create a new UUID because this is new & doesn't exist.
        var notification: LocalNotificationManager.LocalNotification!
        if toDoItem.notificationID == nil {
            notification = LocalNotificationManager.LocalNotification(id: UUID().uuidString, title: nameField.text!, dateComponents: dateComponents)
        } else {
            notification = LocalNotificationManager.LocalNotification(id: toDoItem.notificationID!, title: nameField.text!, dateComponents: dateComponents)
        }
        toDoItem.notificationID = notification.id
        manager.notifications.append(notification)
        manager.schedule()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
        //toDoItem.date = sender.date
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension ListDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return datePickerHidden ? 0 : datePicker.frame.height
        case notesTextViewIndexPath:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            datePickerHidden = !datePickerHidden
            dateLabel.textColor = datePickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
