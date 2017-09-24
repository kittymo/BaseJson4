# BaseJson4

![CocoaPods](https://img.shields.io/cocoapods/v/BaseJson4.svg) ![Platform](https://img.shields.io/badge/platforms-iOS%209.0+%20%7C%20macOS%2010.10+-3366AA.svg)

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

如果你有使用 SwiftyJSON 看起來像這樣:

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
  }
```






