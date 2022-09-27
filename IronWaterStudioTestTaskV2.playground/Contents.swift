import Foundation

enum Failed: Error {
    case invalidInputString
}

func versionCompare(_ firstVersion: String, _ secondVersion: String) throws -> ComparisonResult {
    var decimalChars = CharacterSet.decimalDigits
    decimalChars.insert(".")
    
    if firstVersion.isEmpty || secondVersion.isEmpty {
        throw Failed.invalidInputString
    }
 
    if !decimalChars.isSuperset(of: CharacterSet(charactersIn: firstVersion)) || !decimalChars.isSuperset(of: CharacterSet(charactersIn: secondVersion)) {
        throw Failed.invalidInputString
    } // Решил использовать isSuperset так как он быстрее работает чем isSubset (тесты ниже)

    let separator = "."
    
    var firstComponents = firstVersion.components(separatedBy: separator).map{ $0 == "" ? "0" : $0 }
    var secondComponents = secondVersion.components(separatedBy: separator).map{ $0 == "" ? "0" : $0 }
    
    let difference = firstComponents.count - secondComponents.count
    
    if difference == 0 {
        return firstComponents.joined(separator: separator).compare(secondComponents.joined(separator: separator), options: .numeric)
    } else {
        let zero = Array(repeating: "0", count: abs(difference))
        if difference > 0 {
            secondComponents.append(contentsOf: zero)
        } else {
            firstComponents.append(contentsOf: zero)
        }
        return firstComponents.joined(separator: separator)
            .compare(secondComponents.joined(separator: separator), options: .numeric)
    }
}

do {
    let result = try versionCompare("..00", ".0.")
    
    switch result {
    case .orderedAscending:
        print("Версия 1 ниже версии 2")
    case .orderedSame:
        print("Версии одинаковы")
    case .orderedDescending:
        print("Версия 1 выше версии 2")
    }
}
catch Failed.invalidInputString {
    print("Версия не валидна")
}

// MARK: - Тесты

var decimalChars = CharacterSet.decimalDigits
decimalChars.insert(".")

let charsSet: Set<Character> = ["1","2","3","4","5","6","7","8","9",".","0"]

let version = "234234.565757...5858.8..9.7.68.6.7.7.6.7"

func check1(_ v: String) -> Bool {
    if v.rangeOfCharacter(from: decimalChars.inverted) != nil {
        return false
    }
    return true
}
    
func check2(_ v: String) -> Bool {
    if CharacterSet(charactersIn: v).isSubset(of: decimalChars) {
        return true
    }
    return false
}

func check3(_ v: String) -> Bool {
    if decimalChars.isSuperset(of: CharacterSet(charactersIn: v)) {
        return true
    }
    return false
}

func check4(_ v: String) -> Bool {
    if Set<Character>(Array(v)).subtracting(charsSet).isEmpty{
        return true
    }
    return false
}

check1(version)
check2(version)
check3(version)
check4(version)

let time1 = CFAbsoluteTimeGetCurrent()
for _ in 0..<100000 {
    check1(version)
}
print("Test1(decimalChars.inverted) = \(CFAbsoluteTimeGetCurrent() - time1)")

let time2 = CFAbsoluteTimeGetCurrent()
for _ in 0..<100000 {
    check2(version)
}
print("Test2(isSubset) = \(CFAbsoluteTimeGetCurrent() - time2)")

let time3 = CFAbsoluteTimeGetCurrent()
for _ in 0..<100000 {
    check3(version)
}
print("Test3(isSuperset) = \(CFAbsoluteTimeGetCurrent() - time3)")

let time4 = CFAbsoluteTimeGetCurrent()
for _ in 0..<100000 {
    check4(version)
}
print("Test4(subtracting) = \(CFAbsoluteTimeGetCurrent() - time4)")


