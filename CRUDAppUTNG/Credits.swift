//
//  Credits.swift
//  CRUDAppUTNG
//
//  Created by Alumno on 5/10/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit
import Firebase

class Credits: UIViewController, UITabBarDelegate, UITableViewDataSource {

    var refCredits: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var lbMessage: UILabel!
    
    @IBAction func btAddCredit(_ sender: UIButton) {
        addCredit()
    }
    
    
    @IBOutlet weak var tvCreditsList: UITableView!
    
    var creditsList = [CreditModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let credit = creditsList[indexPath.row]
        
        let alertController = UIAlertController(title: credit.name, message: "Add new values to update credit", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            let id = credit.id
            let name = alertController.textFields?[0].text
            let type = alertController.textFields?[1].text
            
            self.updateCredit(id: id!, name: name!, type: type!)
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
            self.deleteCredit(id: credit.id!)
        }
        
        alertController.addTextField{(UITextField) in
            UITextField.text = credit.name
        }
        
        alertController.addTextField{(UITextField) in
            UITextField.text = credit.type
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updateCredit(id: String, name: String, type: String) {
        let credit = [
            "id": id,
            "creditName": name,
            "creditType": type
        ]
        refCredits.child(id).setValue(credit)
        lbMessage.text = "Credit updated"
    }
    
    func deleteCredit(id: String) {
        refCredits.child(id).setValue(nil)
    }
    
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditsList.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellCredit
        
        let credit: CreditModel
        
        credit = creditsList[indexPath.row]
        
        cell.lbName.text = credit.name
        cell.lbType.text = credit.type
        
        return cell
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()
        
        refCredits = Database.database().reference().child("credits");
        
        refCredits.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>0{
                self.creditsList.removeAll()
                
                for credits in snapshot.children.allObjects as![DataSnapshot]{
                    let creditObject = credits.value as? [String: AnyObject]
                    let creditName = creditObject?["creditName"]
                    let creditType = creditObject?["creditType"]
                    let creditId = creditObject?["id"]
                    
                    let credit = CreditModel(id: creditId as! String?, name: creditName as! String?, type: creditType as! String?)
                    
                    self.creditsList.append(credit)
                    
                }
                
                self.tvCreditsList.reloadData()
                
            }
            
        })
        
    }
    
    func addCredit(){
        let key = refCredits.childByAutoId().key
        
        let credit = ["id":key,
                      "creditName": txtName.text! as String,
                      "creditType": txtType.text! as String
        ]
        refCredits.child(key!).setValue(credit)
        
        lbMessage.text = "Credit Added"
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
