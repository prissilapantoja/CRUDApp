//
//  Incomes.swift
//  CRUDAppUTNG
//
//  Created by Alumno on 5/10/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit
import Firebase

class Incomes: UIViewController, UITabBarDelegate, UITableViewDataSource {

    var refIncomes: DatabaseReference!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var lbMessage: UILabel!
    
    @IBAction func btAddIncome(_ sender: UIButton) {
        addIncome()
    }
    
    @IBOutlet weak var tvIncomesList: UITableView!
    
    var incomesList = [IncomeModel]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let income = incomesList[indexPath.row]
        
        let alertController = UIAlertController(title: income.name, message: "Add new values to update income", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
            let id = income.id
            let name = alertController.textFields?[0].text
            let type = alertController.textFields?[1].text
            
            self.updateIncome(id: id!, name: name!, type: type!)
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
            self.deleteIncome(id: income.id!)
        }
        
        alertController.addTextField{(UITextField) in
            UITextField.text = income.name
        }
        
        alertController.addTextField{(UITextField) in
            UITextField.text = income.type
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated:true, completion: nil)
    }
    
    func updateIncome(id: String, name: String, type: String) {
        let income = [
            "id": id,
            "incomeName": name,
            "incomeType": type
        ]
        refIncomes.child(id).setValue(income)
        lbMessage.text = "Income updated"
    }
    
    func deleteIncome(id: String) {
        refIncomes.child(id).setValue(nil)
    }
    
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomesList.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCellIncome
        
        let income: IncomeModel
        
        income = incomesList[indexPath.row]
        
        cell.lbName.text = income.name
        cell.lbType.text = income.type
        
        return cell
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()
        
        refIncomes = Database.database().reference().child("incomes");
        
        refIncomes.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>0{
                self.incomesList.removeAll()
                
                for incomes in snapshot.children.allObjects as![DataSnapshot]{
                    let incomeObject = incomes.value as? [String: AnyObject]
                    let incomeName = incomeObject?["incomeName"]
                    let incomeType = incomeObject?["incomeType"]
                    let incomeId = incomeObject?["id"]
                    
                    let income = IncomeModel(id: incomeId as! String?, name: incomeName as! String?, type: incomeType as! String?)
                    
                    self.incomesList.append(income)
                    
                }
                
                self.tvIncomesList.reloadData()
                
            }
            
        })
    }
    
    func addIncome(){
        let key = refIncomes.childByAutoId().key
        
        let income = ["id":key,
                      "incomeName": txtName.text! as String,
                      "incomeType": txtType.text! as String
        ]
        refIncomes.child(key!).setValue(income)
        
        lbMessage.text = "Income Added"
        
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
