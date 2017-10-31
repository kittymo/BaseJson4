# BaseJson4

![CocoaPods](https://img.shields.io/cocoapods/v/BaseJson4.svg) ![Platform](https://img.shields.io/badge/platforms-iOS%209.0+%20%7C%20macOS%2010.10+-3366AA.svg)

BaseJson4 makes you more easier to transform data type from JSON to Object or reverse.</br>
\*support only Swift 4 and above


1. [Why use BaseJson4 in your project?](#why-use-basejson4-in-your-project)
2. [Features](#features)
3. [Integration](#integration)
	- [CocoaPods](#CocoaPods-(iOS-9+,-OS-X-10.10+))
	- [Manually](#manually)
4. [Requirements](#requirements)
5. [Usage](#usage)
   - [Json to Object](#1-json-to-object)
   - [Object to Json](#2-object-to-json)
   - [Different name mapping](#3-different-name-mapping)


## Why use BaseJson4 in your project?


We want to handle data which is JSON string getting from backend with service API, we have to use`Dictionary`or`Array`to transform or parse data in to the model, until Swift 4 `Codable` introduced.

The BaseJson4 base on new protocol`Codable`could let you more easier to use`Codable`feature and more clean your own code and more importantly reduce low-level errors by hands with autocomplete.

Handle the *object property* rather than handle a string *["user"]* make Xcode to check is it correct.<br>


With [BaseJson4](/BaseJson4/BaseJson4.swift) just use User Object, *User* could be Class or Struct all you have to do this:

```swift
  if let user = jsonStr.toObj(type: User.self) {
    print("userName= \(user.name)")
    let age = user.age
  }
```

With [official Apple Example](https://developer.apple.com/swift/blog/?id=37) would look like this:

```swift
if let statusesArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]],
    let user = statusesArray[0]["user"] as? [String: Any],
    let userName = user["name"] as? String {
    print("userName= \(user.name)")
}
```

 
With [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) would look like this:

```swift
let json = JSON(data: dataFromNetworking)
if let userName = json[0]["user"]["name"].string {
    print("userName= \(user.name)")
}
```
see, [BaseJson4](/BaseJson4/BaseJson4.swift) more clean right?


## Features

- JSON String --> Object Model
- Object Model --> JSON String
- Different name mapping
- Specific Date format transformer
- Print the contents of an object

## Requirements

- iOS 9.0+ | macOS 10.10+
- Xcode 9
- Swift 4.0

## Integration

#### CocoaPods (iOS 9+, OS X 10.10+)

You can use [CocoaPods](http://cocoapods.org/) to install`BaseJson4`by adding it to your`Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
	pod 'BaseJson4'
end
```

#### Manually

To use this library in your project manually you may:  
	
1. Download [BaseJson4.swift](https://github.com/kittymo/BaseJson4/blob/master/BaseJson4/BaseJson4.swift) file form github
2. add the [BaseJson4.swift](https://github.com/kittymo/BaseJson4/blob/master/BaseJson4/BaseJson4.swift) file in your project
3. no more step 2


## Usage
#### 1. Json to Object

Here is a Json string
```json
{"id":66, "birthday":"1997-05-08", "height": 180.61, "name":"kittymo", "gender":"M", "age": 29, "friends": [ {"name":"Bill", "isFriend": true}, {"name":"Allen", "isFriend": false, "test":1} ]}
```

First of all create the object Model, in here we using class, of course you can using struct if you want.


```swift
class User: BaseJson4 {
    var name: String? = nil
    var gender: String? = nil
    var age: Int = 0
    var birthday: String? = nil
    var friends: [Friend]? = nil
    var height: Double = 0    
}

class Friend: BaseJson4 {
    var name: String? = nil
    var isFriend: Bool = false
}

```


The `String`/`Data`has been`extension`by [BaseJson4](/BaseJson4/BaseJson4.swift) with method`toObj`<br>

Source of Json data types could be`String`or`Data`you can use like this code follow:


```swift
let jsonStr = "{"id":66, "birthday":"1997-05-08", "height": 180.61, "name":"kittymo", "gender":"M", "age": 29, "friends": [ {"name":"Bill", "isFriend": true}, {"name":"Allen", "isFriend": false, "test":1} ]}"

if let user = jsonStr.toObj(type: User.self) {
    let desc = user.description()   // description() method can print all of properties in this object 
    print("Object content ==> \(desc)")

    // .... just use this obeject

    let age = user.age
    let name = user.name
    if let friends = user.friends {
        for friend in friends {
          print("friend name=\(friend.name)")
        }
    }
}
```

Just one line code, `String.toObj`, we succeed transform from a *Json string* to an *object Model* <br>
here is output log on console follow:

```text
Object content ==> 
<User:
 name=Optional("kittymo")
 gender=Optional("M")
 age=29
 birthday=Optional("1997-05-08")
 friends=Array count=2 [ <Friend: name=Optional("Bill") isFriend=true>, <Friend: name=Optional("Allen") isFriend=false> ]
 height=180.61
>

friend name=Optional("Bill")
friend name=Optional("Allen")
```

Is it easy, right?

Remember *Json string* has a property named `birthday`, it's a birthday date, we want to it's data typs can transform `from String`  to `Data` Object.

Here is show you how to do that follow:

Just change two place (where comment) follow:

```swift
class User: BaseJson4 {
    var name: String? = nil
    var gender: String? = nil
    var age: Int = 0
    var birthday: Date? = nil       // <--- change type annotation here from String to Data
    var friends: [Friend]? = nil
    var height: Double = 0    
    
    static func dateFormats() -> [String: String]? {
        return [CodingKeys.birthday.stringValue: "yyyy-MM-dd"]  // <--- define date format you want like: yyyy-MM-dd
    }
}
```

That's it, property `birthday` is became `Date` date type! yeh!<br>
after modify the output log on console follow


```text
Object content ==>  
<User:
 name=Optional("kittymo")
 gender=Optional("M")
 age=29
 birthday=Optional(1997-05-07 16:00:00 +0000)
 friends=Array count=2 [ <Friend: name=Optional("Bill") isFriend=true>, <Friend: name=Optional("Allen") isFriend=false> ]
 height=180.61
>
```
<hr>


#### 2. Object to Json

How do we do transform from an `Object` to `Json string`?.

Well, it's very simple, just one line code.


```swift
let jsonStr = user.toJson()
print("json string = \(jsonStr)")
```

the output log on console follow:

```text
json string = {"age":29,"gender":"M","friends":[{"name":"Bill","isFriend":true},{"name":"Allen","isFriend":false}],"name":"kittymo","birthday":"1997-05-08","height":180.61000000000001}
```

It is suitable way if for machine read with default format
If you want to print out Json format for human read, add the argument like `user.toJson(.prettyPrinted)`


```swift
let jsonStr = user.toJson(.prettyPrinted)  // <--- modify by argument: prettyPrinted 
```

the output will be nice to human read, log on console follow:

```text
json string = {
  "age" : 29,
  "gender" : "M",
  "friends" : [
    {
      "name" : "Bill",
      "isFriend" : true
    },
    {
      "name" : "Allen",
      "isFriend" : false
    }
  ],
  "name" : "kittymo",
  "birthday" : "1997-05-08",
  "height" : 180.61000000000001
}
```
<hr>

#### 3. Different name mapping

When we get Json string which is not Swift style, we want to modify that to be Swift style,
you can using *different name mapping*
here is show you how to do different name mapping way.


```json
 {"user_id":66, "user_name":"阿媛", "valid":true, "sex":"F", "style":"村菇"}
```
We want let the column`user_name`to be `name`, `user_id` to be `userId`

Modify`User`object model, and add CodingKeys like follow:

```swift
class User: BaseJson4 {
    var userId: Int = 0
    var name: String? = nil
    var gender: String? = nil
    var valid: Bool = false
    var style: String? = nil
    
    //  Reset CodingKeys to do different name mapping
    
    enum CodingKeys : String, CodingKey {
        case userId = "user_id"     // different name mapping
        case name = "user_name"     // different name mapping
        case gender = "sex"         // different name mapping
        case valid	// same name
        case style	// same name 
    }
}
```

Notice: if you have reset `CodingKeys` to do different name mapping, all of properties must be set with same name, *Do not be ignored if the column name is the same name.* 

<p>

The method Json -> Object just the same before: 

```swift
let jsonStr = "{\"user_id\":66, \"user_name\":\"阿媛\", \"valid\":true, \"sex\":\"F\", \"style\":\"村菇\"}"
print("input json string ==> \(jsonStr)")
        
// json string --> Object
if let user = jsonStr.toObj(type: User.self) {
            
	let desc = user.description()
        print("Object content ==> \(desc)")

	// Object --> json string
	let ss = user.toJson(.prettyPrinted)
	print("json string = \(ss)")
}
```

the output log on console follow:

```text
input json string ==> {"user_id":66, "user_name":"阿媛", "valid":true, "sex":"F", "style":"村菇"}

Object content ==> 
<User:
 userId=66
 name=Optional("阿媛")
 gender=Optional("F")
 valid=true
 style=Optional("村菇")
>

 json string = {
  "sex" : "F",
  "style" : "村菇",
  "user_id" : 66,
  "valid" : true,
  "user_name" : "阿媛"
}
```

Just rename the column name, it's perfect mapping in to the object model.


Translated by TerryCK

