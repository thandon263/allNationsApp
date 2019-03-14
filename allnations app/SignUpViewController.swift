//
//  SignUpViewController.swift
//  allnations app
//
//  Created by Thando Ncube on 2019-03-13.
//  Copyright © 2019 Dev360Groupe. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUp: UIBarButtonItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUp.isEnabled = false
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
    
    @IBAction func onPressSignUp(_ sender: Any) {
        
        signUp.isEnabled = false
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
            
            if (error != nil) {
                if (error!._code == 17999) {
                    self.errorMessage.text = "Invalid Email Address"
                } else {
                    print(error?.localizedDescription ?? nil!)
                    self.errorMessage.text = error?.localizedDescription ?? nil!
                }
            } else {
                self.errorMessage.text = "Registered Successfully"
                
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
                    
                self.databaseRef.child("user_profiles").child(user!.user.uid).child("email").setValue(self.email.text!)
                    
                    self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                })
            }
        })
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        
        if((!(email.text?.isEmpty)! ) && !(password.text?.isEmpty)!){
            
            signUp.isEnabled = true
        } else {
            signUp.isEnabled = false
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
