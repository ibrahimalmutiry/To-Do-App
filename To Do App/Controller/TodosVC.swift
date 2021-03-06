//
//  TodosVC.swift
//  To Do App
//
//  Created by ibrahim almutiry on 28/11/2021.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    // this is a new struct
    
    var todoArray: [Todo] = []
    
    @IBOutlet weak var todoTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoArray = getTodos()
        
        // this Notification for add button:
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // this Notification for edit button:
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrnetTodoEdited"), object: nil)
        
        // this Notification for delete button:
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoDeleted), name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil)
        
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
    }
    
    @objc func newTodoAdded(notification: Notification){
        if let myTodo = notification.userInfo?["addedTodo"] as? Todo {
            todoArray.append(myTodo)
            todoTableView.reloadData()
            StoreData.storeTodo(todo: myTodo)
        }
    }
    
    @objc func currentTodoEdited(notification: Notification){
        if let myTodoEdit = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedIndex"] as? Int {
                todoArray[index] = myTodoEdit
                todoTableView.reloadData()
                StoreData.updateTodos(todo: myTodoEdit, index: index)
            }
        }
    }
    
    @objc func currentTodoDeleted(notification: Notification){
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int {
            todoArray.remove(at: index)
            todoTableView.reloadData()
            StoreData.deleteTodos(index: index)
        }
    }
    
 
    
    func getTodos() -> [Todo]{
        var todos: [Todo] = []
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        let context = appdelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
           let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTodo in result {
                print(managedTodo)
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                
                var todoImage: UIImage? = nil
                if let imageContext = managedTodo.value(forKey: "image") as? Data {
                   todoImage = UIImage(data: imageContext)
                }
                
                let todo = Todo(title: title ?? "" , details: details ?? "", image: todoImage)
                
                todos.append(todo)
            }
        }catch{
            print("------error from getTodo------")
        }
        return todos
    }
}

extension TodosVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        // Title:
        cell.todoTitleLb.text = todoArray[indexPath.row].title
        // Image:
        if todoArray[indexPath.row].image != nil {
            cell.todoImage.image = todoArray[indexPath.row].image
        }else{
            cell.todoImage.image = UIImage(named: "img")
        }
        // to make this image corner radius:
        cell.todoImage.layer.cornerRadius = 20
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // to hide selected shadow:
        tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = todoArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC
        
        // to show viewControler at present sheet:
        if let viewControler = vc {
            viewControler.todo = todo
            viewControler.index = indexPath.row
            
            navigationController?.pushViewController(viewControler, animated: true)
        }
        
       
    }
}














