//
//  ViewController.swift
//  AuthWithParse
//
//  Created by Patrick Santana on 18/02/2019.
//  Copyright © 2019 Patrick Santana. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var fieldEmail: UITextField!
    @IBOutlet weak var fieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        print("sign up action")
        
        // validate fields
        if (fieldEmail.text == "" || fieldPassword.text == ""){
            displayAlert(title: "Validation Form", message: "Enter email and password")
        }
        
        let user = PFUser()
        user.username   = fieldEmail.text
        user.password   = fieldPassword.text
        user.email      = fieldEmail.text
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 50,height: 50))
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(indicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        user.signUpInBackground { (success: Bool, error: Error?) in
            indicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if (success) {
                // The object has been saved.
                print("user created")
            } else {
                // There was a problem, check error.description
                self.displayAlert(title: "Could not create an account", message: error!.localizedDescription)
            }
        }
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        print("login action")
        // validate fields
        if (fieldEmail.text == "" || fieldPassword.text == ""){
            displayAlert(title: "Validation form", message: "Enter email and password")
        }
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 50,height: 50))
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(indicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        PFUser.logInWithUsername(inBackground:fieldEmail.text!, password:fieldPassword.text!,  block: {(user: PFUser?, error: Error?) in
            
            indicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if (user != nil){
                print ("Login sucessful")
            }else{
                if (error != nil){
                    self.displayAlert(title: "Could not login", message: error!.localizedDescription)
                }else{
                    self.displayAlert(title: "Wrong credentials", message: "Try again")
                }
            }
        })
    }
    
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true, completion: nil)
    }
}
