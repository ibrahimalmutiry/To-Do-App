//
//  DetailsVC.swift
//  To Do App
//
//  Created by ibrahim almutiry on 03/12/2021.
//

import UIKit

class DetailsVC: UIViewController {
    
    var todo: Todo!
    var index: Int!
    
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoTitleLable: UILabel!
    @IBOutlet weak var todoDetailsLable: UILabel!
    
    @IBOutlet weak var emptyViewTitle: UIView!
    @IBOutlet var divider: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this Notification for edit button:
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrnetTodoEdited"), object: nil)
        
       
        if todo.image != nil {
            todoImageView.image = todo.image
        }else{
            todoImageView.image = UIImage(named: "img")
        }
        
        setupUI()
        
        todoImageView.layer.cornerRadius = 10
        emptyViewTitle.layer.cornerRadius = 10
    }
    
    
    //MARK: Functions
    
    @objc func currentTodoEdited(notification: Notification){
        if let myTodoEdit = notification.userInfo?["editedTodo"] as? Todo {
            self.todo = myTodoEdit
            setupUI()
        }
    }
    
    func setupUI(){
        todoTitleLable.text = todo.title
        todoDetailsLable.text = todo.details
        todoImageView.image = todo.image
    }
    
    
    //MARK: Buttons
    
    @IBAction func editButton(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC {
            viewController.isCreation = false
            viewController.editedTodo = todo
            viewController.editedTodoIndex = index
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = MyAlertViewController(
            title: "تنبيه الحذف",
            message: "هل انت متأكد من إتمام عملية الحذف؟",
            imageName: "warning_icon")

        alert.addAction(title: "متأكد", style: .default) { alert in
            self.navigationController?.popViewController(animated: true)

            // this Notification for delete button:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteTodo"), object: nil, userInfo: ["deletedTodoIndex": self.index!])

            let alert = UIAlertController(title: "تم الحذف", message: "تم حذف المهمة بنجاح", preferredStyle: .alert)
            
            
            let closeAction = UIAlertAction(title: "اغلاق", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }

            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: { })
        }
        alert.addAction(title: "إلغاء", style: .cancel) { alert in
            self.navigationController?.popViewController(animated: true)

        }
        present(alert, animated: true, completion: nil)
    }
}
