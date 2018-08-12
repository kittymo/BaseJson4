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
        
  
        
        class TestModel: BaseJson4 {
            var name: String? = nil
            var 年齡: Int = 0
            var 什麼鬼: String? = nil
            enum CodingKeys : String, CodingKey {
                case name = "中文名字"
                case 年齡
                case 什麼鬼 = "%#abc"
            }
        }

        // ------------------------------
        // SAMPLE 1
        // JSON String --> Object Model
        let str = "{\"中文名字\":\"阿媛\", \"年齡\":18, \"%#abc\":\"什麼怪名字\"}"
        if let test = TestModel(json: str) {
            print(test)
            
            // Object Model --> JSON String
            print(test.jsonString)      // OUTPUT: {"年齡":18,"%#abc":"什麼怪名字","中文名字":"阿媛"}
            // Object Model --> Dictionary
            print(test.dictionary)      // OUTPUT: ["%#abc": 什麼怪名字, "中文名字": 阿媛, "年齡": 18]
        }
        
        // ------------------------------
        // SAMPLE 2
        // Dictionary --> Object Model
        let dict: Dictionary<String, Any> = ["中文名字":"阿媛", "年齡":18, "%#abc":"什麼怪名字"]
        if let test = TestModel(dict: dict) {
            print(test)
            
            // Object Model --> JSON String
            print(test.jsonString)      // OUTPUT: {"年齡":18,"%#abc":"什麼怪名字","中文名字":"阿媛"}
            // Object Model --> Dictionary
            print(test.dictionary)      // OUTPUT: ["%#abc": 什麼怪名字, "中文名字": 阿媛, "年齡": 18]
        }
        
        
        
        
        // ------------------------------
        // Other Sample
        // ------------------------------

        let jsonStr = "{\"id\":66, \"ext\":\"1123\", \"birthday\":\"1997-05-08\", \"height\": 180.61, \"name\":\"小軒\", \"gender\":\"M\", \"age\": 29, \"friends\": [ {\"name\":\"小明\", \"isFriend\": true}, {\"name\":\"小華\", \"isFriend\": false, \"test\":1} ]}"
        print("Source JSON String ==> \(jsonStr)")
        
        // JSON String --> Object Model (Method 1)
        if let user = User(json: jsonStr) {
            let desc = user.description()
            print("(Method 1) Object ==> \(desc)")
        }
        
        // JSON String --> Object Model (Method 2)
        if let user = jsonStr.toObj(type: User.self) {
            let desc = user.description()
            print("(Method 2) Object ==> \(desc)")
            
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
            
            print("array description=\(array.description())")
            
            let ss = array.toJson()
            print("輸出的 json 字串 = \(ss)")
        }
        

        
    }

}

