//
//  RefreshableViewModel.swift
//  SwiftModulesDemo
//
//  Created by ash on 2020/8/25.
//  Copyright © 2020 cc. All rights reserved.
//

import Foundation

struct RefreshableModel: HandyJSON {
    
    var _id : String = ""
    var created : String = ""
    var desc : String = ""
    var publishedAt : String = ""
    var source : String = ""
    var type : String = ""
    var url : String = ""
    var used : String = ""
    var who : String = ""
    
    init() { }
}

class RefreshableViewModel: NSObject, RefreshControllable {
    
    var refreshSubject = PublishSubject<Bool>()
    
    var loadDataSubject = PublishSubject<Bool>()
    
    let networking = Networking<GankApi>()
    
    var dataSources = BehaviorRelay<[RefreshableModel]>(value: [])
    
    fileprivate var pageIndex = 1
    fileprivate var pageSize = 10
    
    override init() {
        super.init()
        
        let requestPage = loadDataSubject.flatMap { [weak self] (bb) -> Observable<[RefreshableModel]> in
            guard let self = self else { return Observable.empty() }
            return self.fetchList(bb)
        }
        
        let values = refreshSubject.filter({ $0 }).flatMap { [weak self] (_) -> Observable<[RefreshableModel]> in
            guard let self = self else { return Observable.empty() }
            return self.loadDataSubject
                    .withLatestFrom(requestPage)
                    .scan([], accumulator: { $0 + $1 })
        }
        
        values.do(onNext: { [weak self] (arr) in
            self?.cc.refreshStatus.accept(.endHeaderRefresh)
            self?.cc.refreshStatus.accept(.endFooterRefresh)
        }).subscribe { (_) in
            
        }.disposed(by: rx.disposeBag)
        
        values.bind(to: dataSources).disposed(by: rx.disposeBag)
    }
    
    fileprivate func fetchList(_ reload: Bool) -> Observable<[RefreshableModel]> {
        pageIndex = reload ? 1 : pageIndex+1
        return networking.rx.cacheRequest(.girls(size: pageSize, index: pageIndex)).mapArray(RefreshableModel.self, atKeyPath: "data")
    }
    
}
