//
//  ViewController.swift
//  ToDoList
//
//  Created by Ayush Rajpal on 18/06/24.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        var content = UIListContentConfiguration.cell()
        content.text = item.title
        cell.contentConfiguration = content
//        print("Cell for row at \(indexPath.row): \(itemArray[indexPath.row])")
        
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK:- add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // add item button is pressed
            
            let newItem = Item()
            newItem.title = textFiled.text!
            self.itemArray.append(newItem)
            self.saveItem()
            
        }
        
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func saveItem() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding the data \(error)")
        }
        self.tableView.reloadData()
        
    }

}

