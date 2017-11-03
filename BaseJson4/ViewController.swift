//
//  ViewController.swift
//  BaseJson4
//
//  Created by Hello Kitty on 2017/9/23.
//  Copyright © 2017年 Hello Kitty. All rights reserved.
//
import Foundation
import UIKit

class Friend: BaseJson4 {
    var name: String? = nil
    var isFriend: Bool = false
}

class User: BaseJson4 {
    var name: String? = nil
    var gender: String? = nil
    var age: Int = 0
    var birthday: Date? = nil
    var friends: [Friend]? = nil
    var height: Double = 0
    
    static func dateFormats() -> [String: String]? {
        return [CodingKeys.birthday.stringValue: "yyyy-MM-dd"]
    }
    
    /*
    enum CodingKeys : String, CodingKey {
        case name
        case gender = "sex"        // 異名對映
        case age
        case friends
        case birthday
    }
    */
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonStr = "{\"id\":66, \"birthday\":\"1997-05-08\", \"height\": 180.61, \"name\":\"小軒\", \"gender\":\"M\", \"age\": 29, \"friends\": [ {\"name\":\"小明\", \"isFriend\": true}, {\"name\":\"小華\", \"isFriend\": false, \"test\":1} ]}"
        print("輸入的 json 字串 ==> \(jsonStr)")
        
        // json字串 --> Object
        if let user = jsonStr.toObj(type: User.self) {
            
            print("user.name=\(String(describing: user.name))")
            
            let desc = user.description()
            print("物件內容 ==> \(desc)")
            if let friends = user.friends {
                for friend in friends {
                    print("friend name=\(String(describing: friend.name))")
                }
            }
            // Object --> json字串
            let ss = user.toJson(.prettyPrinted)
            print("輸出的 json 字串 = \(ss)")
            
            
            let dict = user.toDictionary()
            print("dict = \(dict)")
        }

        
        
        // Array Object
        print("\n============ Test Array Object")
        
        let jsonArrayStr = "[{\"name\":\"eee\", \"age\":44, \"height\":164, \"birthday\":\"1997-05-08\"},{\"name\":\"eee\", \"age\":3, \"height\":174, \"birthday\":\"1997-05-08\"}]"
        
        if let array = jsonArrayStr.toObj(type: [User].self) {
            print("array=\(String(describing: array))")
            for u in array {
                print("u=\(u.description())")
            }
            
            let ss = array.toJson()
            print("輸出的 json 字串 = \(ss)")
        }
        
    
        
    }

}

