//
//  BaseJson4.swift
//  BaseJson4
//
//  Created by KittyMo on 2017/9/23.
//  Updated by KittyMo on 2018/8/12.
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
    func toObj<T: BaseJson4>(type: [T].Type) -> [T]? {
        if let data = self.data(using: .utf8) {
            return data.toObj(type: type)
        }
        return nil
    }
}

public extension Data {
    func toObj<T: BaseJson4>(type: T.Type) -> T? {
        do {
            let decoder = createDecoder(T.self)
            return try decoder.decode(type, from: self)
        } catch {
            print("BaseJson4 toObj failed=\(error)")
            return nil
        }
    }
    
    func toObj<T: BaseJson4>(type: [T].Type) -> [T]? {
        do {
            let decoder = createDecoder(T.self)
            return try decoder.decode(type, from: self)
        } catch {
            print("BaseJson4 toObj failed=\(error)")
            return nil
        }
    }
    
    private func createDecoder<T: BaseJson4>(_ type: T.Type) -> JSONDecoder {
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
        return decoder
    }
}

public extension Dictionary {
    func toObj<T: BaseJson4>(type: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return jsonData.toObj(type: type)
        } catch {
            print("============\nBaseJson4 Dictionary.toObj failed=\(error)\n============\n")
            return nil
        }
    }
}

public extension BaseJson4 {
    
    init?(json: String) {
        guard let s = json.toObj(type: Self.self) else { return nil }
        self = s
    }
    
    init?(jsonData: Data) {
        guard let s = jsonData.toObj(type: Self.self) else { return nil }
        self = s
    }

    init?(dict: Dictionary<String, Any>) {
        guard let s = dict.toObj(type: Self.self) else { return nil }
        self = s
    }

    
    
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
    
    var dictionary: Dictionary<String, Any> {
        let str = self.toJson()
        if let data = str.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
    
    var dictionaryNoCodingKeys: Dictionary<String, Any> {
        return toDictionary()
    }
    
    var jsonString: String {
        return self.toJson()
    }
    
    var jsonData: Data? {
        return self.toJson().data(using: .utf8)
    }
    
    // convert Object to Dictionary
    func toDictionary() -> Dictionary<String, Any> {
        let mirror: Mirror = Mirror(reflecting: self)
        var dict = Dictionary<String, Any>()
        for p in mirror.children {
            if let label = p.label {
                dict[label] = p.value
            }
        }
        return dict
    }
    
    var description: String {
        return self.description()
    }
}

public extension Array where Element : BaseJson4 {
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
            if let ds = Element.dateFormats(), let key = ec.codingPath.last?.stringValue, let df = ds[key] {
                f.dateFormat = df
            }
            let stringData = f.string(from: date)
            try container.encode(stringData)
        }
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
    
    func description(_ newLine: Bool = true) -> String {
        return """
        Array<\(Element.self)> [
            \(map{$0.description(newLine)}.joined())
        ]\n
        """
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

