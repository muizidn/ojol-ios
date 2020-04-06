//
//  AnalyticsManager.swift
//  Ojol
//
//  Created by Muis on 13/02/20.
//

import Foundation
import Sentry
import RxSwift

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    func initialize() -> Observable<Void> {
        Observable.create { (o) in
            do {
                Client.shared = try Client(dsn: "https://d4162e5e789b42d8801d885ffb593a06@sentry.io/2490132")
                try Client.shared?.startCrashHandler()
            } catch let error {
                log.error("\(error)")
            }
            return Disposables.create()
        }
    }
}
