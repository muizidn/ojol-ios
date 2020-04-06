import Foundation
import RxSwift

protocol Navigator {
    func back() -> Observable<Void>
}

extension Navigator {
    func back() -> Observable<Void> {
        return .just(())
    }
}
