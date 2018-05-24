//
//  UserRegister.swift
//  DMT
//
//  Created by Boza Rares-Dorian on 28/04/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

// STRUCTURA DATELOR DE PE SERVER ESTE DE FORMA

/**
   JSON = {
    msg = success;
    response =     {
        avatar = "..";
        email = "stefan@buzoianu.ro";
        "id_user" = 11;
        "nr_telefon" = 0751129406;
        nume = buzoianu;
        parola = 72a3dcef165d9122a45decf13ae20631;
        prenume = stefan;
        status = 1;
        "tip_user" = 1;
    };
}
*/

import Foundation
struct UserDetails: Codable {
    
    let nume: String?
    let prenume: String?
    let email: String?
    let parola: String?
    let telefon: String?
    let tipUser: String?
    let idUser: String?
    let avatar: String?
    let status: String?

    private enum CodingKeys: String, CodingKey{
        case nume
        case prenume
        case email
        case parola
        case telefon = "nr_telefon"
        case tipUser = "tip_user"
        case idUser = "id_user"
        case avatar
        case status
    }
}

struct UserRegister: Codable{
    let msg: String?
    let response: UserDetails?
}
