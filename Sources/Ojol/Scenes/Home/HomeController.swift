//  
//  HomeController.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//
import UIKit
import RxSwift
import RxCocoa
import Material

final class HomeController: BaseController {
    var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    private lazy var child = GenericToolbarController<__XibHomeController>()
    
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
        child.vc.btnNextView.rx.tap
            .bind(to: viewModel.input.launchNext)
            .disposed(by: disposeBag)
        
        child.vc.btnBack.rx.tap
            .bind(to: viewModel.input.back)
            .disposed(by: disposeBag)
        
        child.vc.btnSaySomething.rx.tap
            .subscribe(onNext: {
                fatalError()
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

final class __XibHomeController: BaseController, InterfaceBuilderController {
    @IBOutlet weak var btnNextView: UIButton!
    @IBOutlet weak var btnSaySomething: UIButton!
    
    let v1 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareToolbar()
        
        v1.depthPreset = .depth3
        v1.cornerRadiusPreset = .cornerRadius3
        v1.motionIdentifier = "v1"
        v1.backgroundColor = Material.Color.green.base
        view.add(v1) { v in
            v.centerXToSuperview()
            v.bottomToSuperview()
            v.width(100)
            v.height(100)
        }
    }
    
    private(set) lazy var btnBack = IconButton.init(image: Asset.Figma.icBack.image, tintColor: .white)
    
    fileprivate func prepareToolbar() {
        guard let toolbar = toolbarController?.toolbar else {
            return
        }
        
        toolbar.title = "Material"
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .left
        
        toolbar.detail = "Build Beautiful Software"
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .left
        
        toolbar.backgroundColor = Material.Color.blue.darken2
        toolbar.rightViews = [
            IconButton(image: UIImage(named: "inbox"))
        ]
        toolbar.leftViews = [
            btnBack
        ]
        
        toolbarController?.configure({ (t) in
            t.statusBarStyle = .lightContent
            t.statusBar.backgroundColor = Material.Color.blue.darken2
        })
    }
}
