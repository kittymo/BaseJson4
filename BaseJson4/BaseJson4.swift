//
//  BaseJson4.swift
//  BaseJson4
//
//  Created by KittyMei on 2017/9/23.
//  Copyright © 2017年 Hello Kitty. All rights reserved.
//

import Foundation

public protocol BaseJson4: Codable {
    static func dateFormats() -> [String: String]?
}


public extension String {
    func toObj<T: BaseJson4>(type: T.Type) -> T? {
        if let data = self.data(using: .utf8) {
            return data.toObj(type: type)
        }
        return nil
    }
    func toObj<T: BaseJson4>(type: [T.Type]) -> [T]? {
        if let data = self.data(using: .utf8) {
            return data.toObj(type: type)
        }
        return nil
    }
}

public extension Data {
    func toObj<T: BaseJson4>(type: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN")
            decoder.dateDecodingStrategy = .custom {
                let container = try $0.singleValueContainer()
                let datestr = try container.decode(String.self)
                let f = DateFormatter()
                f.locale = .current
                f.timeZone = TimeZone.current
                f.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let ds = T.dateFormats(), let key = $0.codingPath.last?.stringValue, let df = ds[key] {
                    f.dateFormat = df
                }
                if let d = f.date(from: datestr) {
                    return d
                }
                return Date(timeIntervalSince1970: 0)
            }
            return try decoder.decode(T.self, from: self)
        } catch {
            print("BaseJson4 toObj failed=\(error)")
            return nil
        }
    }

    func toObj<T: BaseJson4>(type: [T.Type]) -> [T]? {
        do {
            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN")
            decoder.dateDecodingStrategy = .custom {
                let container = try $0.singleValueContainer()
                let datestr = try container.decode(String.self)
                let f = DateFormatter()
                f.locale = .current
                f.timeZone = TimeZone.current
                 f.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let ds = T.dateFormats(), let key = $0.codingPath.last?.stringValue, let df = ds[key] {
                    f.dateFormat = df
                }
                if let d = f.date(from: datestr) {
                    return d
                }
                return Date(timeIntervalSince1970: 0)
            }
            return try decoder.decode([T].self, from: self)
        } catch {
            print("BaseJson4 toObj failed=\(error)")
            return nil
        }
    }
}

public extension BaseJson4 {
    func toJson(_ outputFormatter: JSONEncoder.OutputFormatting = []) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatter
        encoder.nonConformingFloatEncodingStrategy =  .convertToString(positiveInfinity: "INF", negativeInfinity: "-INF", nan: "NaN")
        encoder.dateEncodingStrategy = .custom { (date, ec) in
            var container = ec.singleValueContainer()
            let f = DateFormatter()
            f.locale = .current
            f.timeZone = TimeZone.current
            f.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let ds = Self.dateFormats(), let key = ec.codingPath.last?.stringValue, let df = ds[key] {
                f.dateFormat = df
            }
            let stringData = f.string(from: date)
            try container.encode(stringData)
        }
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}

public extension BaseJson4 {
    static func dateFormats() -> [String: String]? {
        return nil
    }
    static func userInfo() -> [CodingUserInfoKey: Any]? {
        return nil
    }

    // 印出物件內全部屬性
    func description(_ newLine: Bool = true) -> String {
        let mirror: Mirror = Mirror(reflecting: self)
        var out = ""
        if newLine {
            out += "\n"
        }
        out += "<\(type(of: self)):"
        if newLine {
            out += "\n"
        }
        for p in mirror.children {
            if let arr = p.value as? Array<Any> {
                var aout: String = ""
                for a in arr {
                    if aout != "" {
                        aout += ", "
                    }
                    if let bj4 = a as? BaseJson4 {
                        aout += bj4.description(false)
                    } else {
                        aout += "\(a)"
                    }
                }
                out += " \(p.label!)=Array count=\(arr.count) [ " + aout + " ]"
            } else {
                out += " \(p.label!)=\(p.value)"
            }
            if newLine {
                out += "\n"
            }
        }
        out += ">"
        if newLine {
            out += "\n"
        }
        return out
    }
}

struct User: BaseJson4 {
  var name: String
}

var jsonStr = "{\"name\" : \"danny\"}"
if let user = jsonStr.toObj(type: User.self) {
  precondition(user.name=="danny", "Should pass")
}
jsonStr = "[{\"name\" : \"danny\"}]"
if let users = jsonStr.toObj(type: [User.self]) {
  precondition(users[0].name=="danny", "Should pass")
}
