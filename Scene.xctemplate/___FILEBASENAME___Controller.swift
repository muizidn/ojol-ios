//  ___FILEHEADER___
import UIKit
import RxSwift
import RxCocoa
import Material
    
final class ___VARIABLE_productName:identifier___Controller: BaseController {
  var viewModel: ___VARIABLE_productName:identifier___ViewModel!
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
  
  override func layoutUI() {
  }
  
  // MARK: Binding
  
  private func startBind() {
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