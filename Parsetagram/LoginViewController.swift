//
//  LoginViewController.swift
//  
//
//  Created by Christian Alexander Valle Castro on 11/16/19.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    //Mark :: Properties
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   //
    
    @IBAction func signIn(_ sender: Any) {
        let username = usernameField.text!
        let mypassword = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: mypassword) { (user,error) in
            if  user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else{
                print("Error login in \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        let user = PFUser()
            user.username = usernameField.text
            user.password = passwordField.text
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else{
                    print ("Error signing up:  \(error?.localizedDescription)")
                }
            }
    }
    
    @IBAction func ontouch(_ sender: Any) {  // to hide keyboard
        view.endEditing(true)
        
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
