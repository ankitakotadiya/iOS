import UIKit

let menuItem = ["Burger": 45.50, "Pizza": 30.0, "Paratha": 23.78, "Icecream": 10, "Noodles": 12.20]
let menu = ["Burger", "Pizza"]

// Filter Dic
var filteredDict: [String: Double] = [:]
for item in menu {
    if let price = menuItem[item] {
        filteredDict[item] = price
    }
}

let filter = Dictionary(uniqueKeysWithValues: menu.compactMap({ key in
    menuItem[key].map({(key,$0)})
}))

let orders = [
    "Alice": [("Apple", 3), ("Banana", 2)],
    "Bob": [("Orange", 1)],
    "Charlie": [("Apple", 5), ("Grapes", 4)],
    "Diana": [("Banana", 6)]
]
let selectedCustomers = ["Alice", "Charlie", "Diana"]

let order = Dictionary(uniqueKeysWithValues: selectedCustomers.compactMap({ customer in
    orders[customer].map({(customer, $0)})
}))

let products = [
    "P001": ("Laptop", 1200.00),
    "P002": ("Smartphone", 800.00),
    "P003": ("Headphones", 150.00),
    "P004": ("Mouse", 25.00)
]
let selectedProductIDs = ["P001", "P003", "P004"]
let priceThreshold = 100.00

let product = Dictionary(uniqueKeysWithValues: selectedProductIDs.compactMap({ key in
    if let (name, price) = products[key], price > priceThreshold {
        return (key, (name, price))
    } else {
        return nil
    }
}))

let users: [[String: Any]] = [
    ["id": 1, "name": "Alice", "age": 17],
    ["id": 2, "name": "Bob", "age": 25],
    ["id": 3, "name": "Charlie", "age": 30],
    ["id": 4, "name": "Daisy", "age": 16]
]

let userNames = users.filter { dic in
    (dic["age"] as? Int ?? 0) > 18
}.compactMap({ dic in
    (dic["name"] as? String)?.uppercased()
}).joined(separator: ", ")

let prices: [Double] = [99.99, 49.99, 150.00, 30.00, 200.00]
let threshold: Double = 50.00

let averagePrice = prices.filter({$0 > threshold}).reduce(0, +) / Double(prices.filter({$0 > threshold}).count)
print(averagePrice)

let strings: [String?] = ["Hello", nil, "", "World", "Swift", nil, "Programming"]
let empty = strings.compactMap({$0}).filter({!$0.isEmpty})

let productPrices: [String: Double] = [
    "Laptop": 1200.00,
    "Smartphone": 800.00,
    "Headphones": 150.00,
    "Mouse": 25.00
]

// Reduce
let summ = productPrices.filter({$0.value > priceThreshold}).reduce(0) { partialResult, dic in
    partialResult + dic.value
}

let text = "hello world"

let unique = Set(text).filter({!$0.isWhitespace}).sorted().map({String($0)}).joined()

// Sort
let numbers = [5, 2, 9, 1, 5, 6]
let sorted = numbers.sorted(by: {$0 > $1})
let otherway = numbers.sorted(by: >)
print(otherway)

let words = ["banana", "apple", "cherry", "date"]
print(words.sorted())

struct Person {
    let name: String
    let age: Int
}

let people = [
    Person(name: "Alice", age: 30),
    Person(name: "Bob", age: 25),
    Person(name: "Charlie", age: 35)
]

let sort = people.sorted { person1, person2 in
    person1.age < person2.age
}
print(sort)

let scores: [(name: String, score: Int)] = [
    ("Alice", 85),
    ("Bob", 92),
    ("Charlie", 78)
]

let sortscore = scores.sorted { obj1, obj2 in
    obj1.score > obj2.score
}.map({$0.name})
print(sortscore)

let people1 = [
    Person(name: "Alice", age: 30),
    Person(name: "Bob", age: 25),
    Person(name: "Charlie", age: 30),
    Person(name: "Dave", age: 25)
]

let peoplesort = people1.sorted { person1, person2 in
    if person1.age == person2.age {
        return person1.name < person2.name
    }
    return person1.age < person2.age
}
print(peoplesort)
