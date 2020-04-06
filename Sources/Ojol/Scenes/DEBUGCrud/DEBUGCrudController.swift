#if DEBUG
//
//  DEBUGCrudController.swift
//  Ojol
//
//  Created by Muis on 15/02/20.
//
import UIKit
import RxSwift
import RxCocoa
import Material

final class DEBUGCrudController: BaseController {
    var viewModel: DEBUGCrudViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutNavBar()
        layoutUI()
        startBind()
    }
    
    // MARK: Navbar
    
    private lazy var btnCreateItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    
    private func layoutNavBar() {
        navigationItem.configure { (n) in
            n.rightBarButtonItem = btnCreateItem
        }
    }
    
    // MARK: UI
    
    private let tableView = UITableView()
    
    override func layoutUI() {
        view.add(tableView) { (v) in
            v.edgesToSuperview()
            v.register(DEBUGCRUDTableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    // MARK: Binding
    
    private func startBind() {
        btnCreateItem.rx.tap
            .flatMapLatest({ [unowned self] in
                Observable<DEBUGCrudDomain>.create { (o) in
                    let vc = DEBUGCrudCreateController()
                    vc.model = self.viewModel.repo.repo.newModel()
                    let nav = UINavigationController(
                        rootViewController: vc)
                    self.present(nav, animated: true, completion: nil)
                    vc.onDone = { model in
                        o.onNext(model)
                        o.onCompleted()
                    }
                    vc.onCancel = {
                        o.onCompleted()
                    }
                    return Disposables.create()
                }
            })
            .bind(to: viewModel.input.create)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withLatestFrom(viewModel.output.items,
                            resultSelector: { $1[$0.row] })
            .flatMapLatest({ [unowned self] item in
                Observable<DEBUGCrudDomain>.create { (o) in
                    let vc = DEBUGCrudCreateController()
                    vc.model = item
                    let nav = UINavigationController(
                        rootViewController: vc)
                    self.present(nav, animated: true, completion: nil)
                    vc.onDone = { model in
                        o.onNext(model)
                        o.onCompleted()
                    }
                    vc.onCancel = {
                        o.onCompleted()
                    }
                    return Disposables.create()
                }
            })
            .bind(to: viewModel.input.create)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .withLatestFrom(viewModel.output.items,
                            resultSelector: { $1[$0.row] })
            .compactMap({ $0.get(key: type(of:$0).primaryKey) as? String })
            .bind(to: viewModel.input.delete)
            .disposed(by: disposeBag)
        
        viewModel.output.items
            .drive(tableView.rx.items) { (tb, row, model) -> UITableViewCell in
                let cell = tb.dequeueReusableCell(withIdentifier: "Cell") as! DEBUGCRUDTableViewCell
                cell.lText.text = model.asCellString
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

final class DEBUGCRUDTableViewCell: UITableViewCell {
    private(set) lazy var lText = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        lText.numberOfLines = 0
        lText.lineBreakMode = .byWordWrapping
        contentView.add(lText) { v in
            v.edgesToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DEBUGCrudCreateController: UIViewController {
    var model: DEBUGCrudDomain!
    override func viewDidLoad() {
        super.viewDidLoad()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        for field in type(of: model).fields {
            field.view.value = model.get(key: field.field)
            let lField = UILabel()
            lField.text = field.field
            stack.addArrangedSubview(lField)
            stack.addArrangedSubview(field.view)
        }
        view.backgroundColor = .white
        view.add { (v: UIScrollView) in
            v.edgesToSuperview(usingSafeArea: true)
            v.add(stack) { v in
                v.topToSuperview()
                v.left(to: self.view, offset: 10)
                v.right(to: self.view, offset: -10)
                v.bottomToSuperview()
            }
        }
        
        
        navigationItem.title = "DEBUGCrud - Create Or Edit"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDone))
    }
    
    var onDone: (DEBUGCrudDomain) -> Void = {_ in}
    var onCancel: () -> Void = {}
    
    @objc
    private func btnDone() {
        for field in type(of: model).fields {
            model.save(value: field.view.value, key: field.field)
        }
        onDone(model)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func btnCancel() {
        dismiss(animated: true, completion: nil)
    }
}
#endif
