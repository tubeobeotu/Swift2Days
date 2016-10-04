//: Playground - noun: a place where people can play

import UIKit
//Generic Functions
/*
//Đề bài hãy viết hàm cộng 2 số Int, Double và in ra đúng kiểu
    func adderInt(_ x: Int, _ y: Int) -> Int
    {
        return x + y
    }
    func adderDouble(_ x: Double, _ y: Double) -> Double
    {
        return x + y
    }

//Khi sử dụng generic thì không cần quan tâm đến kiểu viết 1 dùng cho tất cả
    func adderGeneric<T: NumericType>(_ x: T, _ y: T) -> T
    {
        print(type(of: x))
        return x + y
    }
    protocol NumericType {
        static func +(lhs: Self, rhs: Self) -> Self
    }

    extension Int: NumericType{}
    extension Double: NumericType{}
    print(adderGeneric(1, 2))
*/

//Struct
/*
struct Queue<Element>{
    fileprivate var elements = [Element]()
    init(array: [Element]) {
        self.elements = array
    }
    mutating func enqueue(newElement: Element) {
        elements.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.remove(at: 0)
    }
}
var q = Queue(array: [])

q.enqueue(newElement: 4)
q.enqueue(newElement: 2)
q.enqueue(newElement: "Nguyen Van Tu")
q.dequeue()
q.dequeue()
q.dequeue()
q.dequeue()
*/

//Extension
/*
extension Queue
{
    func printAllValues()
    {
        for element in self.elements
        {
            print(element)
        }
    }
}
q.printAllValues()
*/

//Constraints
//Tìm index trong 1 mảng bất kỳ
/*
struct Queue<Element>{
    fileprivate var elements = [Element]()
    init(array: [Element]) {
        self.elements = array
    }
    mutating func enqueue(newElement: Element) {
        elements.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.remove(at: 0)
    }
    func findIndex<T: Equatable>(of valueToFind: T) -> Int? {
        for (index, value) in self.elements.enumerated() {
            if let elementValue = value as? T
            {
                if valueToFind == elementValue
                {
                    return index
                }
            }
        }
        return nil
    }
}
var q = Queue(array: [])

q.enqueue(newElement: 4)
q.enqueue(newElement: 2)
q.enqueue(newElement: "Nguyen Van Tu")
q.findIndex(of: "Nguyen Van Tu")
*/

//Associated Types
/*
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}
*/

//Where Clauses
/*
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
//         Check that both containers contain the same number of items.
                    if someContainer.count != anotherContainer.count {
                        return false
                    }
                    // Check each pair of items to see if they are equivalent.
                    for i in 0..<someContainer.count {
                        if someContainer[i] != anotherContainer[i] {
                            return false
                        }
                    }
//         All items match, so return true.
        return true
}
extension Array: Container{}
let a = [1, 2, 3, 4]
let b = [1, 2, 3]
print(allItemsMatch(a, b))
*/