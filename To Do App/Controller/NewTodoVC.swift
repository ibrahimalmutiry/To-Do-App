//
//  NewTodoVC.swift
//  To Do App
//
//  Created by ibrahim almutiry on 03/12/2021.
//

import UIKit

class NewTodoVC: UIViewController{
    
    var isCreation = true
    var editedTodo: Todo?
    var editedTodoIndex: Int?
    
    @IBOutlet weak var todoImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var mainButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextView.layer.borderWidth = 0.5
        titleTextField.borderStyle = .roundedRect
        
        mainButton.layer.cornerRadius = 15
        todoImage.layer.cornerRadius = 15
        
        if !isCreation {
            navigationItem.title = "تعديل مهمة"
            
            mainButton.setTitle("تعديل", for: .normal)
            
            mainButton2.setTitle("تغيير صورة", for: .normal)
            mainTitle.text = "اضغط هنا لتعديل الصورة"
         
            
            if let todo = editedTodo {
                titleTextField.text = todo.title
                detailTextView.text = todo.details
                todoImage.image = todo.image
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        if isCreation{
            let todo = Todo(title: titleTextField.text!, details: detailTextView.text, image: todoImage.image)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil, userInfo: ["addedTodo": todo])
            
            let alert = UIAlertController(title: "تم الإضافة", message: "تمت إضافة المهمة بنجاح", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "اغلاق", style: .default) { _ in
                self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailTextView.text = ""
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: { })
            
        }else{
            let todo = Todo(title: titleTextField.text!, details: detailTextView.text, image: todoImage.image)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrnetTodoEdited"), object: nil, userInfo: ["editedTodo": todo, "editedIndex": editedTodoIndex!])
            
            let alert = UIAlertController(title: "تم التعديل", message: "تمت تعديل المهمة بنجاح", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "اغلاق", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
                self.titleTextField.text = ""
                self.detailTextView.text = ""
            }
            alert.addAction(closeAction)
            present(alert, animated: true, completion: { })
        }
      
    }
    
    @IBAction func changeImageButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
}


extension NewTodoVC:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        todoImage.image = image
    }
}








