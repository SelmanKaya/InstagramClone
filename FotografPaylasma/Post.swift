//
//  Post.swift
//  FotografPaylasma
//
//  Created by Selman Kaya on 29.12.2024.
//

import Foundation

class Post{
    
    var email : String
    var yorum : String
    var gorselUrl : String
    
    init(email: String, yorum: String, gorselUrl: String) {
        self.email = email
        self.yorum = yorum
        self.gorselUrl = gorselUrl
    }
}
