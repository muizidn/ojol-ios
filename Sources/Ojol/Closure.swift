/// Eg: Closure<(Int) -> Void>
final class Closure<T> {
    private(set) var completion: T {
        didSet {
            didSetCompletion(completion)
        }
    }
    init(_ completion: T) {
        self.completion = completion
    }
    
    func update(_ completion: T) {
        self.completion = completion
    }
    
    private var didSetCompletion: (T) -> Void = { _ in }
    
    func didSet(_ completion: @escaping (T) -> Void) {
        didSetCompletion = completion
    }
}

extension Closure {
    static func voidReturn() -> Closure<() -> Void> { return .init({}) }
}
