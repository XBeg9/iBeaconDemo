// Playground - noun: a place where people can play

import Cocoa

enum SomeEnum: Int {
    case One, Two, Three
}

class SomeProtocol {
    func doSomething(e: SomeEnum) -> String {
        switch e {
        case .One:
            return "One"
        case .Two:
            return "One"
        case .Three:
            return "Three"
        }
    }
}