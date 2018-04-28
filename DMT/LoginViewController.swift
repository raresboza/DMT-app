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
    
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        view.addGestureRecognizer(tapGesture)
        emailField.delegate = self
        passwordField.delegate = self
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
        let contentInset = UIEdgeInsets(top:0, left: 0, bottom: frame.height + 10, right:0)
        userScrollView.contentInset = contentInset
        userScrollView.scrollIndicatorInsets = contentInset
    }
    
    func KeyboardWillHide(_ notification: Notification) {
        userScrollView.contentInset = UIEdgeInsets.zero
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if (emailField.text?.isEmpty)! || passwordField.text?.isEmpty == true{
            resultLabel.text = ServerRequestConstants.resultErrors.emptyText
            resultLabel.textColor = UIColor.white
            return
        }
        if (emailField.text?.characters.contains("@"))! && emailField.text?.characters.contains(".") == false{
            resultLabel.text = ServerRequestConstants.resultErrors.invalidEmail
            resultLabel.textColor = UIColor.white
            return
        }
        resultLabel.text = ""
        let mail = emailField.text
        let parola = passwordField.text
        var params = Dictionary<String, String>();
    params["mail"] = mail
    params["parola"] = parola
    params["request"] = ServerRequestConstants.JSON.LOGIN_REQUEST_NUMBER
        
                ServerRequestManager.instance.postRequest(params: params as Dictionary<NSString, NSString>, url: ServerRequestConstants.URLS.LOGIN_URL, postCompleted: { (response, msg, json) -> () in
                    if  response != ""  {
                                        if(msg == ServerRequestConstants.JSON.RESPONSE_ERROR) {
                                            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                                                DispatchQueue.main.async {
        
                                                    AlertManager.showGenericDialog(msg, viewController: self)
                                                }
                                            }
                                        } else if(msg == ServerRequestConstants.JSON.RESPONSE_SUCCESS) {
                                            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                                                DispatchQueue.main.async {
        
                                                    print("JSON = \(json!)")
                                                  
                                                   self.performSegue(withIdentifier: "toApp", sender: Any?.self)
                                                    

                                                }
                                            }
                                        }
                                    } else {
                                        AlertManager.showGenericDialog("response from server undefined!!!", viewController: self)
                        
                                    }
        
                
                })
            
            }
        }
        

        

    
    
    
    
    
