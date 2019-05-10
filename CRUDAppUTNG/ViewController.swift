//
//  ViewController.swift
//  CRUDAppUTNG
//
//  Created by Alumno on 5/6/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    var refExpends: DatabaseReference!

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtType: UITextField!
    
    @IBOutlet weak var tvExpends: UITableView!
    
    var expendsList = [ExpendModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let expend = expendsList[indexPath.row]
        
        let alertController = UIAlertController(title: expend.name, message: "Add new values to update expend", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            let id = expend.id
            let name = alertController.textFields?[0].text
            let type = alertController.textFields?[1].text
            
            self.updateExpend(id: id!, name: name!, type: type!)
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
            self.deleteExpend(id: expend.id!)
        }
        
        alertController.addTextField{(UITextField) in
            UITextField.text = expend.name
        }
        
        alertController.addTextField{(UITextField) in
            UITextField.text = expend.type
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updateExpend(id: String, name: String, type: String) {
        let expend = [
            "id": id,
            "expendName": name,
            "expendType": type
        ]
        refExpends.child(id).setValue(expend)
        lbMessage.text = "Expend updated"
    }
    
    func deleteExpend(id: String) {
        refExpends.child(id).setValue(nil)
    }
    
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expendsList.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let expend: ExpendModel
        
        expend = expendsList[indexPath.row]
        
        cell.lbName.text = expend.name
        cell.lbType.text = expend.type
        
        return cell
        
        
    }
    
    @IBAction func btAddExpend(_ sender: UIButton) {
        
        addExpend()
        
    }
    
    @IBOutlet weak var lbMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FirebaseApp.configure()
        
        refExpends = Database.database().reference().child("expends");
        
        refExpends.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>0{
            self.expendsList.removeAll()
                
                for expends in snapshot.children.allObjects as![DataSnapshot]{
                    let expendObject = expends.value as? [String: AnyObject]
                    let expendName = expendObject?["expendName"]
                    let expendType = expendObject?["expendType"]
                    let expendId = expendObject?["id"]
                    
                    let expend = ExpendModel(id: expendId as! String?, name: expendName as! String?, type: expendType as! String?)
                    
                    self.expendsList.append(expend)
                    
                }
                
                self.tvExpends.reloadData()
            
            }
            
        })
        
        
    }

    func addExpend(){
        let key = refExpends.childByAutoId().key
        
        let expend = ["id":key,
                      "expendName": txtName.text! as String,
                      "expendType": txtType.text! as String
                        ]
        refExpends.child(key!).setValue(expend)
        
        lbMessage.text = "Expend Added"
        
    }

}

