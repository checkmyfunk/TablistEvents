//: Playground - noun: a place where people can play

import UIKit


func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 1, 12]
hasAnyMatches(numbers, condition: lessThanTen)

numbers.map({
    (number: Int) -> Int in
    var result = 0
    
    if number % 2 == 0 {
        result = number
    } else {
        result = 0
    }
    
    return result
})

let mappedNumbers = numbers.map({ number in 3 * number })
print(mappedNumbers)

let sortedNumbers = numbers.sort { $0 > $1 }
print(sortedNumbers)


//-----

class Shape {
    var numberOfSides = 0
    var color: String
    var name: String
    
    init(name: String, color: String){
        self.name = name
        self.color = color
    }
    
    func simpleDescription() -> String {
        return "A \(name) has \(numberOfSides) sides."
    }
    func changeColor(color: String){
        self.color = color
    }
}

var shape = Shape(name: "pentagon", color: "blue")
shape.numberOfSides = 5
var shapeDescription = shape.simpleDescription()

