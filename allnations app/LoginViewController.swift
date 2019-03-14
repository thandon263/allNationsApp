//
//  LoginViewController.swift
//  allnations app
//
//  Created by Thando Ncube on 2019-03-13.
//  Copyright © 2019 Dev360Groupe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logIn: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logIn.isEnabled = false
        // Do any additional setup after loading the view.
        self.password.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func onPressCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onPressLogIn(_ sender: Any) {
        
        logIn.isEnabled = false
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: {
            (user, error) in
            
            if (error == nil) {
                self.databaseRef.child("user_profiles").child(user!.user.uid).child("handle").observe(.value, with: {(DataSnapshot) in
                    
                    if (!DataSnapshot.exists()) {
                        // User does not have a handle
                        // Send the user to the handle view
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    } else {
                        // Send the user to the homePage
                        self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    }
                })
            } else {
                
                self.errorMessage.text = error?.localizedDescription
            }
        })
    }
    
    @IBAction func textDidChange(_ sender: Any) {
        
        if((!(email.text?.isEmpty)! ) && !(password.text?.isEmpty)!){
            
            logIn.isEnabled = true
        } else {
            logIn.isEnabled = false
        }
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
