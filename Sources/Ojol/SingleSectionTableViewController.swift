//
//  SingleSectionTableViewController.swift
//  Ojol
//
//  Created by Muis on 25/02/20.
//

import UIKit
import RxCocoa
import RxSwift
import XLPagerTabStrip

class SingleSectionTableViewController<Cell: ReusableCell>: UITableViewController, IndicatorInfoProvider {
    
    private(set) lazy
    var dataSourceBinder = Binder<[Cell.Item]>(self) { (this, rooms) in
        this.dataSource = rooms
    }
    
    private var dataSource = [Cell.Item]() {
        didSet {
            tableView.reloadData()
            setEmptyDataSourceState(
                dataSourceCount: dataSource.count
            )
        }
    }
    
    var emptyDataSourceController: EmptyDataSourceController?
    
    func setEmptyDataSourceState(dataSourceCount: Int) {
        #if DEBUG
        let emptyVc = emptyDataSourceController!
        #else
        guard let emptyVc = emptyDataSourceController else { return }
        #endif
        if dataSourceCount == 0 {
            addChild(emptyVc)
            tableView.backgroundView = emptyVc.view
            emptyVc.didMove(toParent: self)
            tableView.separatorStyle = .none
        } else {
            emptyVc.removeFromParent()
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: title, image: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Cell.registerSelf(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cell.dequeue(from: tableView)
        let item = dataSource[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    let didSelectRowAt = PublishSubject<IndexPath>()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectRowAt.onNext(indexPath)
    }
}

protocol ReusableCell: UITableViewCell {
    associatedtype Item
    func configure(item: Item)
    static func registerSelf(in tableView: UITableView)
}

extension ReusableCell {
    static var identifier: String { "\(Self.self)" }
    
    static func dequeue(from tableView: UITableView) -> Self {
        guard let this = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            fatalError("cannot dequeue identifier \(identifier), maybe not registered yet")
        }
        guard let thisSelf = this as? Self else {
            fatalError("Type is \(type(of: this))")
        }
        return thisSelf
    }
}
