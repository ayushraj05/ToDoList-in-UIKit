//
//  ViewController.swift
//  ToDoList
//
//  Created by Ayush Rajpal on 18/06/24.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") ?? "")
        
        searchBar.delegate = self
        loadItems()

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
    
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // add item button is pressed
            
            let newItem = Item(context: self.context)
            newItem.title = textFiled.text ?? ""
            newItem.done = false
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
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving data \(error)")
        }
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    

}
// MARK: - SearchBar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Safe unwrapping of the search bar text
        if let searchText = searchBar.text, !searchText.isEmpty {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Clear the search and reload all items if the search bar is empty
        if searchText.isEmpty {
            loadItems() // Load all items
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


