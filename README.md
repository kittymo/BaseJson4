# BaseJson4

![CocoaPods](https://img.shields.io/cocoapods/v/BaseJson4.svg) ![Platform](https://img.shields.io/badge/platforms-iOS%209.0+%20%7C%20macOS%2010.10+-3366AA.svg)

[English](/README.eng.md)<br>

BaseJson4 讓你輕鬆的把 Json字串 轉換到 物件模型, 同樣也能把模型轉出 Json字串<br>
*此套件只適用 Swift 4.0 以上


## 為什麼要用這個?

當我們呼叫一個 Service API, 後端伺服器經常是回應一個 JSON字串, 過去 Swift 3 只能轉換成字典(Dictionary)或陣列(Array), 直到現在 Swift 4 才能直接轉換成一個自訂的物件模型, 這個套件讓你輕鬆使用 Swift 4 的這項特徵.

原本舊的作法可能看起來像這樣:

```swift
if let statusesArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]],
    let user = statusesArray[0]["user"] as? [String: Any],
    let username = user["name"] as? String {
    // Finally we got the username
}
```

如果你有使用 [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 看起來會像這樣:

```swift
let json = JSON(data: dataFromNetworking)
if let userName = json[0]["user"]["name"].string {
  //Now you got your value
}
```

但仍舊有一個缺點, 欄位名稱必須手動輸入, 例如上面範例的 ["user"] , 手打名稱可能有機會輸入錯字, 或一時忘記完整名字.

那麼, 使用 BaseJson4 後看起來會像這樣:

```swift
  if let user = jsonStr.toObj(type: User.self) {
    // 直接使用 User 物件, User 可以是一個 Class 或 Struct
    print("user.name=\(user.name)")
    let age = user.age
  }
```
以操作物件屬性的方式來使用資料欄位, 大大減少因為手誤打錯字造成的bug<br>


## 系統需求 Requirements

- iOS 9.0+ | macOS 10.10+
- Xcode 9
- Swift 4.0

## 功能特徵 Features

- JSON String --> Object Model
- Object Model --> JSON String
- 欄位異名對映
- 日期指定格式轉換
- 傾印 Object 內容

## 如何安裝 使用CocoaPods (iOS 9+, OS X 10.10+)

你可以使用 [CocoaPods](http://cocoapods.org/) 來安裝, 把`BaseJson4`加到你的`Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
	pod 'BaseJson4'
end
```

## 如何安裝 手動Manually

1. 下載本套件的 [BaseJson4.swift](https://github.com/kittymo/BaseJson4/blob/master/BaseJson4/BaseJson4.swift) 檔
2. 把這個檔案加進你的 xcode 專案裡
3. 安裝完成了


## 如何使用 Usage
## 1. Json to Object

我們先用一段 json字串 來示範
```json
{"id":66, "birthday":"1997-05-08", "height": 180.61, "name":"小軒", "gender":"M", "age": 29, "friends": [ {"name":"小明", "isFriend": true}, {"name":"小華", "isFriend": false, "test":1} ]}
```

首先先建立物件模型(Model), 這裡我們使用 class, 當然你也可以使用 struct
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

json資料來源類型可以是 String 或 Data<br>
BaseJson4 幫 String/Data 加上了一個擴展功能叫做 toObj<br>
例如:
```swift
let jsonStr = "{\"id\":66, \"birthday\":\"1997-05-08\", \"height\": 180.61, \"name\":\"小軒\", \"gender\":\"M\", \"age\": 29, \"friends\": [ {\"name\":\"小明\", \"isFriend\": true}, {\"name\":\"小華\", \"isFriend\": false, \"test\":1} ]}"

if let user = jsonStr.toObj(type: User.self) {
    let desc = user.description()   // description()可以傾印出此物件的所有屬性值
    print("物件內容 ==> \(desc)")
    // .... 已經可以直接使用物件了
    let age = user.age
    let name = user.name
    if let friends = user.friends {
        for friend in friends {
          print("friend name=\(friend.name)")
        }
    }
}
```
我們已經成功的把一段 Json字串 轉成了一個 物件Model, 轉換只需要一行程式碼 String.toObj<br>

輸出的 log 如下:
```text
物件內容 ==> 
<User:
 name=Optional("小軒")
 gender=Optional("M")
 age=29
 birthday=Optional("1997-05-08")
 friends=Array count=2 [ <Friend: name=Optional("小明") isFriend=true>, <Friend: name=Optional("小華") isFriend=false> ]
 height=180.61
>

friend name=Optional("小明")
friend name=Optional("小華")
```

是不是很輕鬆容易呢<br>
json字串中有一欄叫做 birthday, 它是一個生日日期, 我們可能會希望它能直接轉成一個 Date 物件<br>
接下來我們示範如何使用日期格式<br>
首先把我們的 User 物件的 birthday 改成 Date 類型
```swift
class User: BaseJson4 {
    var name: String? = nil
    var gender: String? = nil
    var age: Int = 0
    var birthday: Date? = nil       // <--- 改成 Date類型
    var friends: [Friend]? = nil
    var height: Double = 0    
    
    static func dateFormats() -> [String: String]? {
        return [CodingKeys.birthday.stringValue: "yyyy-MM-dd"]  // <--- 指定格式為yyyy-MM-dd
    }
}
```
這樣一來 birthday 就變成了一個 Date 物件了<br>
修改後輸出的 log 如下:
```text
物件內容 ==> 
<User:
 name=Optional("小軒")
 gender=Optional("M")
 age=29
 birthday=Optional(1997-05-07 16:00:00 +0000)
 friends=Array count=2 [ <Friend: name=Optional("小明") isFriend=true>, <Friend: name=Optional("小華") isFriend=false> ]
 height=180.61
>
```
<hr>

## 2. Object to Json

再來我們要如何把一個物件輸出成 json字串呢<br>
很容易, 同樣只要一行程式碼:
```swift
let jsonStr = user.toJson()
print("輸出的 json 字串 = \(jsonStr)")
```
print結果如下:
```text
輸出的 json 字串 = {"age":29,"gender":"M","friends":[{"name":"小明","isFriend":true},{"name":"小華","isFriend":false}],"name":"小軒","birthday":"1997-05-08","height":180.61000000000001}
```
預設是適合傳給api的緊縮格式, 如果你希望產生適合人類閱讀的json可以加上參數
```swift
let jsonStr = user.toJson(.prettyPrinted)  // <--- 加上 prettyPrinted 參數
```
加上參數後的 print結果變成這樣:
```text
輸出的 json 字串 = {
  "age" : 29,
  "gender" : "M",
  "friends" : [
    {
      "name" : "小明",
      "isFriend" : true
    },
    {
      "name" : "小華",
      "isFriend" : false
    }
  ],
  "name" : "小軒",
  "birthday" : "1997-05-08",
  "height" : 180.61000000000001
}
```
<hr>

## 3. 異名對映

有時候 API 回傳的 JSON 欄位名字可能不符合 Swift 的命名習慣, 這時可以使用異名對映<br>
我們用一段簡單的 JSON 字串來示範:

```json
 {"user_id":66, "user_name":"阿媛", "valid":true, "sex":"F", "style":"村菇"}
```
欄位 user_name 我們希望改成 name, user_id 希望改成 userId<br>
修改 User 物件模型, 加上 CodingKeys

```swift
class User: BaseJson4 {
    var userId: Int = 0
    var name: String? = nil
    var gender: String? = nil
    var valid: Bool = false
    var style: String? = nil
    
    // 重設CodingKeys來進行異名對映
    enum CodingKeys : String, CodingKey {
        case userId = "user_id"     // 異名對映
        case name = "user_name"     // 異名對映
        case gender = "sex"         // 異名對映
        case valid	// 同名
        case style	// 同名
    }
}
```

但這裡有一點要特別注意的, 一旦重設了 CodingKeys 做異名對映, 就必須每個欄位都設上去, 同名的欄位也不能省略哦!
<p>
轉換的程式碼則仍然和之前一樣, 沒有改變:

```swift
let jsonStr = "{\"user_id\":66, \"user_name\":\"阿媛\", \"valid\":true, \"sex\":\"F\", \"style\":\"村菇\"}"
print("輸入的 json 字串 ==> \(jsonStr)")
        
// json字串 --> Object
if let user = jsonStr.toObj(type: User.self) {
            
	let desc = user.description()
        print("物件內容 ==> \(desc)")

	// Object --> json字串
	let ss = user.toJson(.prettyPrinted)
	print("輸出的 json 字串 = \(ss)")
}
```

print印出的結果如下:

```text
輸入的 json 字串 ==> {"user_id":66, "user_name":"阿媛", "valid":true, "sex":"F", "style":"村菇"}

物件內容 ==> 
<User:
 userId=66
 name=Optional("阿媛")
 gender=Optional("F")
 valid=true
 style=Optional("村菇")
>

輸出的 json 字串 = {
  "sex" : "F",
  "style" : "村菇",
  "user_id" : 66,
  "valid" : true,
  "user_name" : "阿媛"
}
```

雖然欄位名稱不同了, 但仍然可以完美的對映到物件模型裡.<br>
<br><br>
以上歡迎幫忙翻譯成英文版 ^_^

