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

func adderString(_ x: String, _ y: String) -> String
{
    return x + y
}
//Khi sử dụng generic thì không cần quan tâm đến kiểu cụ thể là gì
func adderGeneric<T: NumericType>(_ x: T, _ y: T) -> T
{
    print(type(of: x))
    return x + y
}
protocol NumericType {
    static func +(lhs: Self, rhs: Self) -> Self
    //Lam vi du chia 2 string
//    static func /(lhs: Self, rhs: Self) -> Self
}

extension Int: NumericType{}
extension Double: NumericType{}
print(adderGeneric(1, 2))
*/

/*
//Struct, Class
struct Queue<Element>{

    fileprivate var elements = [Element]()
    init(array: [Element]) {
        self.elements = array
    }
 //Thêm phần tử vào cuối
    mutating func enqueue(newElement: Element) {
        elements.append(newElement)
    }

 //Lấy ra phần tử ở đầu
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
//q.dequeue()
//q.dequeue()
//q.dequeue()
//q.dequeue()
*/

/*
//Extension
//Bản chất vẫn là struct và class nên có thể sử dụng extension
protocol Print
{
    func printAllValues()
}
extension Queue: Print
{
}
q.printAllValues()
*/

/*
//Constraints
//Tìm index trong 1 mảng bất kỳ
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
            //Liệu có sử dụng được guard trong bài này
//            guard let elementValue = value as? T else{return nil}
//            if valueToFind == elementValue
//            {
//                return index
//            }
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
protocol ContainerFirst {
    associatedtype ItemType
}
func checkType<T: ContainerFirst>(x: T)
{
    print(T.ItemType.self)
    print(type(of: x))
}
extension Int: ContainerFirst{
    typealias ItemType = Int
}
checkType(x: 1)
*/

//Where Clauses
/*
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        //Kiểm tra số phần tử bằng nhau
        print("ok")
        if someContainer.count != anotherContainer.count {
            return false
        }
        //Kiếm tra mỗi cặp theo index có bằng nhau không
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        //Tất cả đúng thì return về true
        return true
}
extension Array: Container{}
let a = [1, 2, 3, 4]
let b = [1, 2, 3, 4]
print(allItemsMatch(a, b))
*/


//protocol NumericType {
//    static func +(lhs: Self, rhs: Self) -> Self
//    //Lam vi du chia 2 string
//    //    static func /(lhs: Self, rhs: Self) -> Self
//}
//protocol IntP
//{
//    associatedtype ItemType
//}
//extension Int: IntP, NumericType{
//    typealias ItemType = Int
//}
//extension Double: IntP
//{
//    typealias ItemType = Double
//}
//
//func testClause<C1: IntP, C2: IntP>(_ c1: C1, _ c2: C2) -> Bool
//where C2: NumericType
//{
//    print(C2.ItemType.self)
//    return true
//}
//testClause(2, 2)

class Employee
{
    var baseSalary:Double = 20
    let timeWorks:Double = 20
    func calculateSalary() -> Double
    {
        return baseSalary * timeWorks
    }
}
class Boss: Employee
{
    override init() {
        super.init()
        baseSalary = 50
    }
}
class Guard: Employee
{
    override init() {
        super.init()
        baseSalary = 25
    }
}
func sort<T: Comparable>(values: inout [T])
{
    for i in 0 ..< values.count
    {
        for j in i+1 ..< values.count
        {
            if (values[i] > values[j])
            {
                let temp = values[i]
                values[j] = values[i]
                values[i] = temp
            }
        }
    }
}

var arr = [1, 9, 8, 7, 6]
print(sort(values: &arr))

