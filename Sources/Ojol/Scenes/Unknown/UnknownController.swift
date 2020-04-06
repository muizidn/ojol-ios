//  
//  UnknownController.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//
import UIKit
import RxSwift
import RxCocoa
import Material

final class UnknownController: BaseController {
    var viewModel: UnknownViewModel!
    private let disposeBag = DisposeBag()
    
    private let child = GenericToolbarController<__UnknownController>()
    
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
    
    override func layoutUI() {
        addChild(child)
        view.add(child.view) { v in
            v.edgesToSuperview()
        }
        child.didMove(toParent: self)
    }
    
    // MARK: Binding
    
    private func startBind() {
        child.vc.btnBack.rx.tap
            .bind(to: viewModel.input.back)
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

final class __UnknownController: BaseController, InterfaceBuilderController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareToolbar()
    }
    
    private(set) lazy var btnBack = IconButton.init(image: Asset.Figma.icBack.image, tintColor: .white)
    
    fileprivate func prepareToolbar() {
        guard let toolbar = toolbarController?.toolbar else {
            return
        }
        
        toolbar.title = "Unknown"
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "typing..."
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .left
        
        toolbar.backgroundColor = Material.Color.blue.darken2
        toolbar.rightViews = [
            IconButton(image: UIImage(named: "inbox"))
        ]
        toolbar.leftViews = [
            btnBack,
            UIView().configure({ (v) in
                v.add(FABButton(image: UIImage(named: "inbox"))) { (v) in
                    v.backgroundColor = .red
                    v.aspectRatio(1)
                    v.heightToSuperview()
                    v.centerXToSuperview()
                }
            }),
        ]
        
        toolbarController?.configure({ (t) in
            t.statusBarStyle = .lightContent
            t.statusBar.backgroundColor = Material.Color.blue.darken2
        })
    }
}
