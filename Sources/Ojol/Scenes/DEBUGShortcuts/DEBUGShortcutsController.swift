#if DEBUG
//
//  DEBUGShortcutsController.swift
//  Ojol
//
//  Created by Muis on 14/02/20.
//
import UIKit
import RxSwift
import RxCocoa
import Material

final class DEBUGShortcutsController: BaseController {
    var viewModel: DEBUGShortcutsViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutNavBar()
        layoutUI()
        startBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutNavBar()
    }
    
    // MARK: Navbar
    
    private func layoutNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.configure { (n) in
            n.title = "DEBUGShortcuts"
        }
    }
    
    // MARK: UI
    
    private let tableView = UITableView()
    
    override func layoutUI() {
        view.add(tableView) { (v) in
            v.edgesToSuperview()
            v.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    // MARK: Binding
    
    private func startBind() {
        tableView.rx.itemSelected
            .bind(to: viewModel.input.launchSceneAtIndex)
            .disposed(by: disposeBag)
        
        viewModel.output.scenes
            .drive(tableView.rx.items) { (tb, row, scene) -> UITableViewCell in
                let cell = tb.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = scene
                return cell
            }
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

#endif
