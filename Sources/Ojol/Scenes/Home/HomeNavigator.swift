//  
//  HomeNavigator.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import Foundation
import RxSwift

protocol HomeNavigator: class, Navigator {
    func launchNext() -> Observable<Void>
}
