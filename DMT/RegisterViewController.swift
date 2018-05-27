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
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        view.addGestureRecognizer(tapGesture)
        profileImageView.addGestureRecognizer(tapImage)
        profileImageView.isUserInteractionEnabled = true
        
     emailField.delegate = self
     passwordField.delegate = self
     nameField.delegate = self
     phoneField.delegate = self
     
    }
    @objc func imageTapped(sender: UIImageView){
        print("ImageView Tapped!")
        let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            present(controller, animated: true, completion: nil)
      
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = image
        let imageStr = convertImageTobase64(format: .png, image: profileImageView.image!)
        
        dismiss(animated: true, completion: nil)
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
        print("text field = \(String(describing: notification.userInfo))")
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
        if emailField.isFirstResponder{
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        }
        if passwordField.isFirstResponder{
            textField.resignFirstResponder()
            nameField.becomeFirstResponder()
        }
        if nameField.isFirstResponder{
            textField.resignFirstResponder()
            phoneField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if (emailField.text?.isEmpty)! == true || passwordField.text?.isEmpty == true || nameField.text?.isEmpty == true || phoneField.text?.isEmpty == true {
            //            resultLabel.text = ServerRequestConstants.resultErrors.emptyText
            //            resultLabel.textColor = UIColor.white
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
            //            resultLabel.text = ServerRequestConstants.resultErrors.invalidEmail
            //            resultLabel.textColor = UIColor.white
            self.view.makeToast(ServerRequestConstants.resultErrors.invalidEmail, duration: 3.0, position:.bottom, title: "Error") { didTap in
                if didTap {
                    print("completion from tap")
                } else {
                    print("completion without tap")
                }
            }
            return
        }
        if phoneField.text?.isNumeric == false {
            self.view.makeToast(ServerRequestConstants.resultErrors.invalidPhoneNumber, duration: 3.0, position:.bottom, title: "Error") { didTap in
                if didTap {
                    print("completion from tap")
                } else {
                    print("completion without tap")
                }
            }
            return
        }
        let phoneNumber = phoneField.text
        let email = emailField.text
        let password = passwordField.text
        let fullName = nameField.text
        var params = Dictionary<String, String>();
        params["nume"] = fullName
        params["prenume"] = "----"
        params["tip"] = "1"
        params["mail"] = email
        params["parola"] = password
        params["telefon"] = phoneNumber
        params["request"] = ServerRequestConstants.JSON.REGISTER_REQUEST_NUMBER
        
        ServerRequestManager.instance.postRequest(params: params as Dictionary<NSString, NSString>, url: ServerRequestConstants.URLS.REGISTER_URL, postCompleted: { (response, msg, json) -> () in
            if  response != ""  {
                if(msg == ServerRequestConstants.JSON.RESPONSE_ERROR) {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        DispatchQueue.main.async {	
                            self.view.makeToast(ServerRequestConstants.resultErrors.invalidEmail, duration: 3.0, position:.bottom, title: "Error") { didTap in
                                if didTap {
                                    print("completion from tap")
                                } else {
                                    print("completion without tap")
                                }
                            }
                            return
                        }
                    }
                } else if(msg == ServerRequestConstants.JSON.RESPONSE_SUCCESS) {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        DispatchQueue.main.async {
                            
                            print("JSON = \(json!)")
                            
                            AlertManager.showGenericDialog(ServerRequestConstants.resultErrors.confirmEmail, viewController: self)
                            
                            
                            
                        }
                    }
                }
            } else {
                AlertManager.showGenericDialog(ServerRequestConstants.resultErrors.unknownError, viewController: self)
                
            }
            
            
        })
        
        
    }
    
    public enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }
    
    func convertImageTobase64(format: ImageFormat, image:UIImage) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = UIImagePNGRepresentation(image)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(image, compression)
        }
        return imageData?.base64EncodedString()
    }
}
extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
