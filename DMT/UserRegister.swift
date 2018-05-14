//
//  UserRegister.swift
//  DMT
//
//  Created by Boza Rares-Dorian on 28/04/2018.
//  Copyright © 2018 Boggy. All rights reserved.
//

import Foundation
struct UserRegister: Codable{
    let nume: String
    let prenume: String
    let email: String
    let parola: String
    let telefon: String
    let tipUser: String
    let idUser: Int
    //
    private enum CodingKeys: String, CodingKey{
        case nume
        case prenume
        case email
        case parola
        case telefon = "nr_telefon"
        case tipUser = "tip_user"
        case idUser = "id_user"
    }
}
