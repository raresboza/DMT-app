//
//  LoginViewController.swift
//  ServerRequestManager
//
//  Created by Synergy on 27/03/18.
//  Copyright © 2018 Synergy.com.nl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var userScrollView: UIScrollView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var passwordField: UITextField!
    
    var userDetailsFromServer: NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        view.addGestureRecognizer(tapGesture)
        emailField.delegate = self
        passwordField.delegate = self
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.rememberSwitchState) == true{
            emailField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.savedEmail)
            passwordField.text = UserDefaults.standard.string(forKey: UserDefaultsKeys.savedPassword)        }
        rememberSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.rememberSwitchState)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let showKeyboard: (Notification) -> Void = { notification in
            self.KeyboardWillShow(notification)
        }
        
        let hideKeyboard: (Notification) -> Void = { notification in
            self.KeyboardWillHide(notification)
        }
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow,
                                               object: nil,
                                               queue: nil,
                                               using: showKeyboard)
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide,
                                               object: nil,
                                               queue: nil,
                                               using: hideKeyboard)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didTap(gesture:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func KeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                
                return
        }
        let contentInset = UIEdgeInsets(top:0, left: 0, bottom: frame.height + 20, right:0)
        userScrollView.contentInset = contentInset
        userScrollView.scrollIndicatorInsets = contentInset
    }
    
    func KeyboardWillHide(_ notification: Notification) {
        userScrollView.contentInset = UIEdgeInsets.zero
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.isFirstResponder{
        textField.resignFirstResponder()
        passwordField.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        return true
    }
    @IBAction func rememberSwitchPressed(sender: UISwitch){
        print("S-a salvat un nou switchState")
       UserDefaults.standard.set(sender.isOn, forKey: UserDefaultsKeys.rememberSwitchState)
        if sender.isOn == false{
            print("Am sters user defaults")
            UserDefaults.standard.set(emailField.text, forKey: UserDefaultsKeys.noEmail)
            UserDefaults.standard.set(passwordField.text, forKey: UserDefaultsKeys.noPassword)
        } else {
            UserDefaults.standard.set(emailField.text, forKey: UserDefaultsKeys.savedEmail)
            UserDefaults.standard.set(passwordField.text, forKey: UserDefaultsKeys.savedPassword)
            print("Am salvat in user defaults")
        }
    }
    @IBAction func loginButton(_ sender: UIButton) {
        self.loginButton.isEnabled = false
        if (emailField.text?.isEmpty)! || passwordField.text?.isEmpty == true{
            self.view.makeToast(ServerRequestConstants.resultErrors.emptyText, duration: 3.0, position:.bottom, title: "Error") { didTap in
                if didTap {
                    print("completion from tap")
                } else {
                    print("completion without tap")
                }
            }
            return
        }
        if (emailField.text?.contains("@"))! == false && emailField.text?.contains(".") == false{
            self.view.makeToast(ServerRequestConstants.resultErrors.invalidEmail, duration: 3.0, position:.bottom, title: "Error") { didTap in
                if didTap {
                    print("completion from tap")
                } else {
                    print("completion without tap")
                }
            }
            return
        }
        
        let mail = emailField.text
        let parola = passwordField.text
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.rememberSwitchState) == true {
            UserDefaults.standard.set(emailField.text, forKey: UserDefaultsKeys.savedEmail)
            UserDefaults.standard.set(passwordField.text, forKey: UserDefaultsKeys.savedPassword)
            print("S-a salvat contul in userdef")
        }
       
        var params = Dictionary<String, String>();
    params["mail"] = mail
    params["parola"] = parola
    params["request"] = ServerRequestConstants.JSON.LOGIN_REQUEST_NUMBER
        
                ServerRequestManager.instance.postRequest(params: params as Dictionary<NSString, NSString>, url: ServerRequestConstants.URLS.LOGIN_URL, postCompleted: { (response, msg, json) -> () in
                    if  response != ""  {
                                        if(msg == ServerRequestConstants.JSON.RESPONSE_ERROR) {
                                            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                                                DispatchQueue.main.async {
                                                    self.loginButton.isEnabled = true
                                                    self.view.makeToast(response, duration: 3.0, position:.bottom, title: "Error") { didTap in
                                                        if didTap {
                                                            print("completion from tap")
                                                        } else {
                                                            print("completion without tap")
                                                        }
                                                    }
                                                   
                                                }
                                            }
                                        } else if(msg == ServerRequestConstants.JSON.RESPONSE_SUCCESS) {
                                            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                                                DispatchQueue.main.async {
                                                    
                                                    // inainte de a face segue vom transfera obiectul json catre HomeVC
                                                    self.userDetailsFromServer = json
                                                    self.performSegue(withIdentifier: "toApp", sender: Any?.self)
                                                        
                                                    }
                                            }
                                        }
                                    } else {
                                        self.loginButton.isEnabled = true
                                        AlertManager.showGenericDialog(ServerRequestConstants.resultErrors.unknownError, viewController: self)
                        
                                    }
        
                
                })
            
            }
    // prepare(for:sender:) se apeleaza inainte de apelul performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toApp" {
            if let vc = segue.destination as? HomeViewController {
                vc.userDetails = userDetailsFromServer
            
            }
        }
    }
    func getImageFromBase64(base64:String) -> UIImage {
        let data = Data(base64Encoded: base64)
        return UIImage(data: data!)!
    }
   
    
        }
        

        

    
    
    
    
    
