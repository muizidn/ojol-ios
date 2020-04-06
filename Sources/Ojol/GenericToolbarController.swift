//
//  AppToolbarController.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import UIKit
import Material

final class GenericToolbarController<C: UIViewController>: ToolbarController {
    var vc: C { rootViewController as! C }
    
    init() {
        super.init(rootViewController: C())
    }
    
    init(root: C) {
        super.init(rootViewController: root)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StarViewController: UIViewController {
    let v1 = UIView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        prepareToolbar()
        
//        v1.depthPreset = .depth3
        v1.cornerRadiusPreset = .cornerRadius3
        v1.motionIdentifier = "v1"
        v1.backgroundColor = Material.Color.green.base
//        view.layout(v1).centerHorizontally().bottom().width(100).height(100)
    }
}

extension StarViewController {
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
        
        toolbarController?.configure({ (t) in
            t.statusBarStyle = .lightContent
            t.statusBar.backgroundColor = Material.Color.blue.darken2
        })
    }
}
