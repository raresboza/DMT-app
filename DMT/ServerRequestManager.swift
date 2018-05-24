//
//  ServerRequestManager.swift
//  ServerRequestManager
//
//  Created by Synergy on 27/03/18.
//  Copyright © 2018 Synergy.com.nl. All rights reserved.
//

import Foundation
import UIKit

enum ServerRequestConstants {
    
    enum  URLS{
        static let LOGIN_TEXT_RESPONSE = "http://students.doubleuchat.com/list.php";
        static let LOGIN_BINARY_RESPONSE = "http://students.doubleuchat.com/list_bin.php";
        static let LOGIN_URL = "http://students.doubleuchat.com/login.php";
        static let REGISTER_URL = "http://students.doubleuchat.com/register.php";
    }
    
    
    enum resultErrors{
        static let invalidEmail = "Adresa de E-Mail tastata nu este valida!"
        static let emptyText = "Unul sau mai multe campuri sunt incomplete!"
        static let invalidPhoneNumber = "Numarul de telefon tastat nu este valid!"
        static let unknownError = "O eroare necunoscuta a avut loc."
        static let confirmEmail = "Inregistrare reusita! Va rugam sa confirmati activarea acestui cont prin verificarea adresei de email tastate."
    }
   
    
    struct JSON {
        static let REGISTER_REQUEST_NUMBER = "1"
        static let LOGIN_REQUEST_NUMBER = "0"
        static let RESPONSE_ERROR = "error"
        static let RESPONSE_SUCCESS = "success"
        static let TAG_RESPONSE = "response"
        static let TAG_ACTION = "action"
        static let TAG_MESSAGE = "msg"
        
    }
    
}

class ServerRequestManager: NSObject {
    
   
    static let instance = ServerRequestManager()
    
    
    func postRequest(params : Dictionary<NSString, NSString>,  url : String, postCompleted: @escaping (_ response: String, _ msg: String, _ json: NSDictionary?) -> ()) {
       
        let paramsStr = createStringFromDictionary(dict: params)
        let paramsLength = "\(paramsStr.count)"
        let requestBodyData = (paramsStr as NSString).data(using: String.Encoding.utf8.rawValue)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        
        request.httpMethod = "POST"
        request.allowsCellularAccess = true
        request.httpBody = requestBodyData;
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(paramsLength, forHTTPHeaderField: "Content-Length")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response , error -> Void in

            do{
                
                let decoder = JSONDecoder()
                let objectJSON = try decoder.decode(UserRegister.self, from: data!)
                // AM PUS OPTIONAL CAMPURILE IN USERREGISTER PENTRU CA ESTE POSIBIL CA SERVERUL SA NU NE FURNIZEZE TOATE INFORMATIILE
                // PRIN URMARE, VERIFIC DACA MI-AU VENIT CAMPURILE SI APOI LE AFISEZ, STIIND CU SIGURANTA CA AM ACELE INFORMATII
                if let message = objectJSON.msg,
                    let email = objectJSON.response?.email,
                    let nume = objectJSON.response?.nume {
                    print("USER Register message - \(message)")
                    print("USER Register email - \(email)")
                    print("USER Register name - \(nume)")
                }


                
            }
            catch let error {
                print("error catch - \(error)")
                
            }
            
            
            
            let json: NSDictionary?
            
            do {
                if(data != nil) {
                    print("data != nil")
                    json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                    
                } else {
                    print("data == nil")
                    postCompleted(ServerRequestConstants.JSON.RESPONSE_ERROR, "An error has occured. Please try again later.", nil)
                    json = nil
                    return
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
                json = nil
            }
            
            

            


            
            if(json == nil) {
                if let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                    print("Error could not parse JSON: '\(jsonStr)'")
                    postCompleted(ServerRequestConstants.JSON.RESPONSE_ERROR, "An error has occured. Please try again later.", nil)
                }

            }
            else {
                if let parseJSON = json {
//                    let response: String = parseJSON[ServerRequestConstants.JSON.TAG_RESPONSE] as? String ?? ""
//                    let message: String = parseJSON[ServerRequestConstants.JSON.TAG_MESSAGE] as? String ?? ""
                    if (params["request"]?.isEqual(ServerRequestConstants.JSON.LOGIN_REQUEST_NUMBER))!{
                        let stringResponse = "In the works"
                        // TO-DO: prelucrarea proprietatii "json"
                   guard let msgValue = json?.value(forKey: ServerRequestConstants.JSON.TAG_MESSAGE) as! String? else{
                    return
                        }
                        if msgValue.isEqual(ServerRequestConstants.JSON.RESPONSE_SUCCESS)
                        {//daca parametrii au fost corecti
                    guard let responseValue = json?.value(forKey: ServerRequestConstants.JSON.TAG_RESPONSE) as! NSDictionary? else{
                        return
                    }
                    print ("msg value este: '\(msgValue)'")
//                    print ("response value este: '\(responseValue)'")
//                            stringResponse = self.createStringFromDictionary(dict: responseValue as! Dictionary<NSString, NSString>)
                            
                        }
//                        else {
//                            stringResponse = json?.value(forKey:ServerRequestConstants.JSON.TAG_RESPONSE) as? String
//                        }
                        print("response in string este:'\(String(describing: stringResponse))'")
                            postCompleted(stringResponse, msgValue, parseJSON)
                    }
                    if (params["request"]?.isEqual(ServerRequestConstants.JSON.REGISTER_REQUEST_NUMBER))!{
                        //TO-DO: prelucrarea proprietatii "json"
                        guard let msgValue = json?.value(forKey: ServerRequestConstants.JSON.TAG_MESSAGE) as! String? else{
                            return
                        }
                        guard let responseValue = json?.value(forKey: ServerRequestConstants.JSON.TAG_RESPONSE) as! String? else{
                            return
                        }
                       print ("msg value este: '\(msgValue)'")
//                         print ("response value este: '\(responseValue)'")
                        postCompleted(responseValue, msgValue, parseJSON)
                    }
                    
                }
                else {
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON1: \(String(describing: jsonStr))")
                    postCompleted(ServerRequestConstants.JSON.RESPONSE_ERROR, "An error has occured. Please try again laterxd.", nil);
                }
            }
        })
        task.resume()
    }
    

    
    private func createStringFromDictionary(dict: Dictionary<NSString, NSString>) -> String {
        var params = String();
        for (key, value) in dict {
            params += "&" + (key as String) + "=" + (value as String);
        }
        return params;
    }
    
    func runOnMainQueue(work: @escaping @convention(block) () -> Swift.Void){
        if Thread.isMainThread{
            work()
        }else{
            DispatchQueue.main.async(execute: work)
        }
        
    }
    
 }


extension ServerRequestManager:NSURLConnectionDelegate {
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("URLConnection error = \(error)")
    }
}


