import Foundation

protocol _Configurable {}
extension _Configurable {
    @discardableResult
    func configure(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: _Configurable {}
