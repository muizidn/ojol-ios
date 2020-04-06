import JGProgressHUD
import RxSwift

enum HUDType {
    case hud(type: HUDContentType)
    case hudOnView(type: HUDContentType, onView: UIView?)
    case flash(type: HUDContentType)
    case alert(title: String, message: String, completion: Closure<(UIAlertController) -> Void>)
    case hide
}

extension HUDType {
    fileprivate static var runningProgressCounter = 0
    static func error(_ message: String) -> HUDType {
        return .alert(title: "Failed", message: message, completion: .addActionOK)
    }
    
    static func progress(_ isLoading: Bool) -> HUDType {
        if isLoading {
            runningProgressCounter += 1
            return .hud(type: .progress)
        } else {
            runningProgressCounter = runningProgressCounter == 0 ? 0 :  runningProgressCounter - 1
            return .hide
        }
    }
    
    static func progress(_ isLoading: Bool, title: String?, subtitle: String?) -> HUDType {
        if isLoading {
            runningProgressCounter += 1
            return .hud(type: .progressLabel(title: title, subtitle: subtitle))
        } else {
            runningProgressCounter = runningProgressCounter == 0 ? 0 :  runningProgressCounter - 1
            return .hide
        }
    }
}

final class ControllerHUD {
    private unowned let vc: UIViewController
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    static var currentHud: JGProgressHUD?
    
    func set(hud: HUDType) {
        if case .hide = hud { if HUDType.runningProgressCounter > 0 { return } }
        guard let view = UIApplication.shared.keyWindow else { log.error("No key window"); return }
        let jghud = JGProgressHUD(style: .extraLight)
        ControllerHUD.currentHud?.dismiss()
        ControllerHUD.currentHud = jghud
        switch hud {
        case .hud(let type):
            type.configure(hud: jghud)
            jghud.show(in: view)
        case .hudOnView(let type, let onView):
            type.configure(hud: jghud)
            jghud.show(in: onView ?? view)
        case .flash(type: let type):
            type.configure(hud: jghud)
            jghud.show(in: view)
            jghud.dismiss(afterDelay: 2.0)
        case .alert(let title, let message, let closure):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            closure.completion(alert)
            vc.present(alert, animated: true, completion: nil)
        case .hide:
            ControllerHUD.currentHud?.dismiss()
        }
    }
}

extension Closure where T == (UIAlertController) -> Void {
    static let addActionOK: Closure<(UIAlertController) -> Void> = .init { (alert) in
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in}))
    }
}

extension HUDType {
    @available(*, deprecated, message: "#this should not be availabel in AppStoreRelease")
    static func unimplemented() -> HUDType {
        return .hud(type: .labeledError(title: "DEBUG Error", subtitle: "Unimplemented"))
    }
}

extension ObservableConvertibleType {
    func unimplemented() -> Observable<HUDType> {
        return asObservable()
            .flatMapLatest({_ in Observable<HUDType>.create({ o in
                o.onNext(.unimplemented())
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    o.onNext(.hide)
                })
                return Disposables.create()
            })})
    }
}

extension HUDType {
    static func requireLoginFlash(login: AnyObserver<Void>, cancelable: Bool = true) -> HUDType {
        return HUDType.flash(type: .label("Please login"))
    }
    
    static func requireLoginAlert(login: AnyObserver<Void>, cancelable: Bool = true) -> HUDType {
        return HUDType.alert(
            title: "Please login",
            message: "",
            completion: .init { (c) in
                let okAction = UIAlertAction(title: "Login", style: .default, handler: { (_) in
                    login.onNext(())
                })
                c.addAction(okAction)
                if cancelable {
                    let cancelAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
                    c.addAction(cancelAction)
                }
            })
    }
}

/// from: PKHUD 😂
public enum HUDContentType {

//    case success
//
//    case error
//
    case progress
    
    case progressLabel(title: String?, subtitle: String?)
//
//    case image(UIImage?)
//
//    case rotatingImage(UIImage?)
//
    case labeledSuccess(title: String?, subtitle: String?)
//
    case labeledError(title: String?, subtitle: String?)
//
//    case labeledProgress(title: String?, subtitle: String?)
//
//    case labeledImage(image: UIImage?, title: String?, subtitle: String?)
//
//    case labeledRotatingImage(image: UIImage?, title: String?, subtitle: String?)
//
    case label(String?)
//
//    case systemActivity
//
//    case customView(view: UIView)
}

extension HUDContentType {
    func configure(hud: JGProgressHUD) {
        switch self {
        case .progress:
            break
        case .progressLabel(let title, let subtitle):
            hud.textLabel.text = title
            hud.detailTextLabel.text = subtitle
        case .labeledSuccess(let title, let subtitle):
            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            hud.textLabel.text = title
            hud.detailTextLabel.text = subtitle
        case .labeledError(let title, let subtitle):
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = title
            hud.detailTextLabel.text = subtitle
        case .label(let text):
            hud.indicatorView = JGProgressHUDInfoIndicatorView()
            hud.textLabel.text = text
        }
    }
}

fileprivate final class JGProgressHUDInfoIndicatorView: JGProgressHUDImageIndicatorView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override init(contentView: UIView?) {
        let v: CGFloat = 33 / 2
        
        let c = UIBezierPath()
        c.addArc(withCenter: .init(x: v , y: v), radius: v, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        c.addArc(withCenter: .init(x: v , y: v), radius: v - 3, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        c.usesEvenOddFillRule = true
        
        let d = UIBezierPath()
        d.addArc(withCenter: .init(x: v , y: 8), radius: 1.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        let l = UIBezierPath()
        l.move(to: .init(x: v, y: 15))
        l.addLine(to: .init(x: v, y: 33 - 8))
        l.lineWidth = 3
        l.lineJoinStyle = .round
        l.lineCapStyle = .round
        
        UIGraphicsBeginImageContext(.init(width: 33, height: 33))
        UIColor.black.setFill()
        UIColor.black.setStroke()
        c.fill()
        d.fill()
        l.stroke()
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        
        super.init(contentView: UIImageView(image: image))
    }
}
