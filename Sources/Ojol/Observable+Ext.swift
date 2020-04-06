import RxSwift
import RxCocoa

extension OjolError {
    static var firstElementNotFound: Error { OjolError
        .msg("First Element Not Found") }
    static func unimplemented(ctx: String) -> Error { OjolError
        .msg("Unimplemented: \(ctx)") }
}

extension ObservableType {
  func asDriverOnErrorJustComplete() -> Driver<Element> {
    asDriver { error in Driver.empty() }
  }
  
  func mapToVoid() -> Observable<Void> {
    map({ _ in })
  }
}

extension ObservableConvertibleType {
    func trackError(_ tracker: ErrorTracker) -> Observable<Element> {
        return tracker.trackError(from: self)
    }
    
    func catchErrorCompleted(with tracker: ErrorTracker) -> Observable<Element> {
        return tracker
            .trackError(from: self)
            .catchError({ _ in .empty() })
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        return activityIndicator.track(source: self)
    }
}

extension ObservableConvertibleType {
    func catchErrorJustCompleted() -> Observable<Element> {
        return asObservable().catchError({ _ in Observable.empty() })
    }
}

extension Observable where Element: Collection {
    
    /// Get the first element or error
    func mustFirst() -> Observable<Element.Element> {
        return flatMapLatest({ collection in
            Observable<Element.Element>.create({ o in
                if let first = collection.first {
                    o.onNext(first)
                    o.onCompleted()
                } else {
                    #if DEBUG
                    fatalError("\(Element.self)")
                    #else
                    o.onError(OjolError.firstElementNotFound)
                    #endif
                }
                return Disposables.create()
            })
        })
    }
}

protocol RespDataProtocol {
    associatedtype Data
    var data: Data { get }
}


extension Observable {
    static func UNIMPLEMENTED(_ ctx: String = "") -> Observable<Element> {
        return .error(OjolError.unimplemented(ctx: ctx))
    }
}

extension Observable {
    static func `do`(completion: @escaping () throws -> Element) -> Observable<Element> {
        Observable.create { (o) in
            do {
                let result = try completion()
                o.onNext(result)
                o.onCompleted()
            } catch {
                o.onError(error)
            }
            return Disposables.create()
        }
    }
}
