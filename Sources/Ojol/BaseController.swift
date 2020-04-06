import UIKit
import RxCocoa
import ViewDSL
import TinyConstraints

#if DEBUG
class __BaseController: UIViewController, LifetimeLoggable {
    static var maxInstanceCount: Int { 1 }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logLifetime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#else
class __BaseController: UIViewController {}
#endif

class BaseController: __BaseController {
    
    func layoutUI() {}
    
    private lazy var hud = ControllerHUD(vc: self)
    private(set) lazy var hudBinder = Binder<HUDType>(hud) { (hud, type) in
        hud.set(hud: type)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hud.set(hud: .hide)
    }
}

protocol InterfaceBuilderController: UIViewController {
    static var nibName: String { get }
    static var bundle: Bundle? { get }
}

extension InterfaceBuilderController {
    static var nibName: String { "\(Self.self)" }
    static var bundle: Bundle? { nil }
}

private extension InterfaceBuilderController {
    static func create() -> Self {
        Self.init(nibName: nibName, bundle: bundle)
    }
}

class XibBaseController<C>: BaseController where C: InterfaceBuilderController {
    var ui: C { _ui! }
    private var _ui: C?
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutUI() {
        let vc = C.create()
        addChild(vc)
        view.add(vc.view) { v in
            v.edgesToSuperview()
        }
        vc.didMove(toParent: self)
        _ui = vc
    }
}
