//
//  RegisterViewController.swift
//  DMT
//
//  Created by Boza Rares-Dorian on 28/04/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var userScrollView: UIScrollView!

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        view.addGestureRecognizer(tapGesture)
     emailField.delegate = self
     passwordField.delegate = self
     nameField.delegate = self
     phoneField.delegate = self
     imagePicker.delegate = self
     
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
        print("text field = \(notification.userInfo)")
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
//    func imageWasTapped(sender: imagewas)
    @IBAction func registerButton(_ sender: Any) {
        var params = Dictionary<String, String>();
        params["nume"] = "Rimon"
        params["prenume"] = "Elex"
        params["tip"] = "1"
        params["mail"] = "rimonelex@babes.com"
        params["parola"] = "flexpecaputau1"
        params["telefon"] = "0722891448"
        params["request"] = ServerRequestConstants.JSON.REGISTER_REQUEST_NUMBER
        
        ServerRequestManager.instance.postRequest(params: params as Dictionary<NSString, NSString>, url: ServerRequestConstants.URLS.REGISTER_URL, postCompleted: { (response, msg, json) -> () in
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
                            
                            AlertManager.showGenericDialog("Succes!", viewController: self)
                            
                            
                            
                        }
                    }
                }
            } else {
                AlertManager.showGenericDialog("response from server undefined!!!", viewController: self)
                
            }
            
            
        })
        
        
    }
}
