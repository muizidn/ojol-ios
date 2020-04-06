#if DEBUG

import Foundation
import Darwin

fileprivate var kTracker: UInt = 0

fileprivate var items: [String:Int] = [:]

protocol LifetimeLoggable: AnyObject {
    /// Make sure this overridable.
    /// Zero means unlimited
    static var maxInstanceCount: Int { get }
    func createKey(_ key: String) -> String
}

fileprivate var classCounter: [String: Int] = [:]

extension LifetimeLoggable {
    fileprivate var key: String { return createKey("\(type(of: self)):\(Unmanaged.passUnretained(self).toOpaque())") }
    fileprivate var classKey: String { return "\(type(of: self))" }
    func logLifetime(caller: StaticString = #function) {
        assert(caller.description.contains("init("),
               "Invoke from init!")
        
        let tracker = Tracker(key: key, classKey: classKey, type: type(of: self))
        objc_setAssociatedObject(self, &kTracker, tracker, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func createKey(_ key: String) -> String {
        return key
    }
}

fileprivate class Tracker {
    let key: String
    let classKey: String
    let type: LifetimeLoggable.Type
    init(key: String, classKey: String, type: LifetimeLoggable.Type) {
        self.key = key
        self.classKey = classKey
        self.type = type
        incrementCounter()
    }
    
    func incrementCounter() {
        
        let maxInstanceCount = type.maxInstanceCount
        var count = items[key] ?? 0
        count += 1
        if maxInstanceCount != 0 {
            assert(count <= maxInstanceCount, "You have memory leak my friend 😂. Now you have \(count) instances where you said that maximum instances allowed is \(maxInstanceCount) for \(key)")
        }
        items[key] = count
        log.info("TRACKER INCREMENT ✨: \(key) = \(count)")
        
        // MARK: #LEAKWARNING
        if let counter = classCounter[classKey] {
            let count = counter + 1
            if maxInstanceCount != 0 {
                if count > maxInstanceCount {
                    log.warning("#LEAKWARNING \(classKey) has \(count) instances")
                }
            }
            
            classCounter[classKey] = count
        } else {
            classCounter[classKey] = 1
        }
    }
    func decrementCounter() {
        var count = items[key] ?? 0
        count -= 1
        items[key] = count
        log.info("TRACKER DECREMENT 💥: \(key) = \(count)")
        
        if let counter = classCounter[classKey] {
            let count = counter - 1
            classCounter[classKey] = count
        } else {
            fatalError()
        }
    }
    
    deinit { decrementCounter() }
}

#endif
