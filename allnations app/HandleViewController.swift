//
//  HandleViewController.swift
//  allnations app
//
//  Created by Thando Ncube on 2019-03-13.
//  Copyright © 2019 Dev360Groupe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HandleViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var startSharing: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        self.handle.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func onPressStartSharing(_ sender: Any) {
        
        _ = self.databaseRef.child("handles").child(self.handle.text!).observe(.value, with: {(snapShot: DataSnapshot) in
            
            if !snapShot.exists() {
                
                    // update the handle in the user_profiles and in the handles node
                    let profiles = self.databaseRef.child("user_profiles")
                    let handles = self.databaseRef.child("handles")
                
                    let userId = Auth.auth().currentUser?.uid as Any
                
                    profiles.child(userId as! String).child("handle").setValue(self.handle.text?.lowercased())
                
                    // Update the name  of the user
                    profiles.child(userId as! String).child("name").setValue(self.fullName.text!)
                
                    // Update the handle in the handle node
                    handles.child(self.handle.text!).setValue(userId as! String)
                
                    // Clear screen
                    self.fullName.text = ""
                    self.handle.text = ""
                
                    // Send User to the home screen
                    self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                
            } else {
                self.errorMessage.text = "Handle already in use!"
            }
        })
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
