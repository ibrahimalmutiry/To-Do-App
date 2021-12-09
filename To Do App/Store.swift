//
//  Store.swift
//  To Do App
//
//  Created by ibrahim almutiry on 09/12/2021.
//

import UIKit
import CoreData

class StoreData {
    static func storeTodo(todo: Todo){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appdelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: manageContext) else { return }
        
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        // to save string in Core Data
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        
        // to save image in Core Data
        if let image = todo.image {
            let imageData = image.pngData()
            todoObject.setValue(imageData, forKey: "image")
        }
        
        do{
            try manageContext.save()
            print("------sucsses------")
        }catch{
            print("------error------")
        }
    }
    
    static  func updateTodos(todo: Todo, index: Int){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            
            if let image = todo.image {
                let imageData = image.pngData()
                result[index].setValue(imageData, forKey: "image")
            }
            
            try context.save()
            
        }catch{
            print("------error from getTodo------")
        }
    }
    
    static  func deleteTodos(index: Int){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = result[index]
            context.delete(todoToDelete)
            
            try context.save()
            
        }catch{
            print("------error from getTodo------")
        }
    }
    
}
