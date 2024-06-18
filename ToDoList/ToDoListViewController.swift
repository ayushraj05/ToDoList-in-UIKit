//
//  ViewController.swift
//  ToDoList
//
//  Created by Ayush Rajpal on 18/06/24.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["ayush", "chiku","stranger"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        var content = UIListContentConfiguration.cell()
        content.text = itemArray[indexPath.row]
        cell.contentConfiguration = content
//        print("Cell for row at \(indexPath.row): \(itemArray[indexPath.row])")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK:- add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // add item button is pressed
            self.itemArray.append(textFiled.text!)
            let newIndexPath = IndexPath(row: self.itemArray.count - 1, section: 0)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

