//
//  AppNavigationController.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import Foundation
import Material
import Motion

final class AppNavigationController: NavigationController {
  override func prepare() {
    super.prepare()
    isMotionEnabled = true
    motionNavigationTransitionType = .fade
    guard let v = navigationBar as? NavigationBar else {
      return
    }
    
    v.backgroundColor = .white
    v.depthPreset = .none
    v.dividerColor = Material.Color.grey.lighten2
  }
}

class RootController: UIViewController {
    
}


import UIKit
import Material

class TransitionViewController: UIViewController {
    fileprivate var fabButton: FABButton!
    
    
    let v1 = UIView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Material.Color.blue.base
        
        v1.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        v1.motionIdentifier = "v1"
        v1.backgroundColor = .green
        view.addSubview(v1)
        
        prepareNavigationItem()
    }
}

fileprivate extension TransitionViewController {
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "New Title"
        navigationItem.detailLabel.text = "Transitioned View"
    }
}

import UIKit
import Material

class ViewController: UIViewController {
  fileprivate let transitionViewController = TransitionViewController()
  
  fileprivate var menuButton: IconButton!
  fileprivate var starButton: IconButton!
  fileprivate var searchButton: IconButton!
  
  fileprivate var fabButton: FABButton!
  
  let v1 = UIView()
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Material.Color.grey.lighten5
    
    v1.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    v1.motionIdentifier = "v1"
    v1.backgroundColor = .purple
    view.addSubview(v1)
    
    prepareMenuButton()
    prepareStarButton()
    prepareSearchButton()
    prepareNavigationItem()
    prepareFABButton()
  }
}

fileprivate extension ViewController {
  func prepareMenuButton() {
    menuButton = IconButton(image: Icon.cm.menu)
  }
  
  func prepareStarButton() {
    starButton = IconButton(image: Icon.cm.star)
  }
  
  func prepareSearchButton() {
    searchButton = IconButton(image: Icon.cm.search)
  }
  
  func prepareNavigationItem() {
    navigationItem.titleLabel.text = "Material"
    navigationItem.detailLabel.text = "Build Beautiful Software"
    
    navigationItem.leftViews = [menuButton]
    navigationItem.rightViews = [starButton, searchButton]
  }
  
  func prepareFABButton() {
    fabButton = FABButton(image: Icon.cm.moreHorizontal)
    fabButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    view.layout(fabButton).width(64).height(64).bottom(24).right(24)
  }
}

fileprivate extension ViewController {
  @objc
  func handleNextButton() {
    navigationController?.pushViewController(transitionViewController, animated: true)
  }
}
