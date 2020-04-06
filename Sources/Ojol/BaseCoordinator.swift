#if DEBUG
class BaseCoordinator<ResultType>: Coordinator<ResultType>, LifetimeLoggable {
    class var maxInstanceCount: Int { return 1 }
    override init() {
        super.init()
        logLifetime()
    }
}
#else
class BaseCoordinator<ResultType>: Coordinator<ResultType> {}
#endif
