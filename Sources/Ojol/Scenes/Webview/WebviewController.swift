//  
//  WebviewController.swift
//  Ojol
//
//  Created by Muis on 12/03/20.
//
import UIKit
import RxSwift
import RxCocoa
import Material
import WebKit

final class WebviewController: BaseController {
    var viewModel: WebviewViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutNavBar()
        layoutUI()
        startBind()
    }
    
    // MARK: Navbar
    
    private func layoutNavBar() {
        navigationItem.configure { (n) in
        }
    }
    
    // MARK: UI
    
    private lazy var childMaterial = GenericToolbarController<WebviewMaterialController>()
    private lazy var webview: WKWebView = {
        let v = WKWebView()
        v.uiDelegate = self
        v.navigationDelegate = self
        return v
    }()
    
    override func layoutUI() {
        addChild(childMaterial)
        view.add(childMaterial.view) { v in
            v.edgesToSuperview()
        }
        childMaterial.didMove(toParent: self)
        
        childMaterial.vc.view.add(webview) { v in
            v.edgesToSuperview()
        }
    }
    
    // MARK: Binding
    
    private func startBind() {
        childMaterial.vc.btnBack.rx.tap
            .bind(to: viewModel.input.back)
            .disposed(by: disposeBag)
        
        viewModel.output.url
            .drive(onNext: { [unowned self] url in
                self.webview.load(URLRequest.init(url: url))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.action
            .drive()
            .disposed(by: disposeBag)
        
        viewModel.output.error
            .map({ HUDType.error($0.localizedDescription) })
            .drive(hudBinder)
            .disposed(by: disposeBag)
        
        viewModel.output.activity
            .map({ HUDType.progress($0) })
            .drive(hudBinder)
            .disposed(by: disposeBag)
        
        viewModel.input.load.onNext(())
    }
}

final class WebviewMaterialController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareToolbar()
    }
    
    
    private(set) lazy var btnBack = IconButton.init(
        image: Asset.Figma.icBack.image)
    
    fileprivate func prepareToolbar() {
        guard let toolbar = toolbarController?.toolbar else {
            return
        }
        
        toolbar.title = ""
        toolbar.titleLabel.textColor = .black
        toolbar.titleLabel.textAlignment = .center
        
        toolbar.backgroundColor = Material.Color.white
        toolbar.rightViews = [
        ]
        toolbar.leftViews = [
            btnBack,
        ]
        
        toolbarController?.configure({ (t) in
            t.statusBarStyle = .lightContent
            t.statusBar.backgroundColor = Material.Color.white
        })
    }
}

extension WebviewController: WKUIDelegate {}

extension WebviewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        hudBinder.onNext(.progress(true))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hudBinder.onNext(.progress(false))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hudBinder.onNext(.error(error.localizedDescription))
    }
}
