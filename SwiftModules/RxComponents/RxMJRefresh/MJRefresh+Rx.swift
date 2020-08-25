//
//  MJRefresh+Rx.swift
//  SwiftModules
//
//  Created by ash on 2020/8/25.
//

import Foundation
import MJRefresh
import RxSwift
import ObjectiveC

public protocol AssociatedObjectStore {}

public extension AssociatedObjectStore {
    
    func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as AnyObject as? T
    }
    
    func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T, ploicy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> T {
        if let object: T = self.associatedObject(forKey: key) {
            return object
        }
        let object = `default`()
        self.setAssociatedObject(object, forKey: key, ploicy: ploicy)
        return object
    }
    
    func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer, ploicy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, key, object, ploicy)
    }
}

typealias RefreshHeader = MJRefreshHeader
typealias RefreshFooter = MJRefreshFooter

public enum RefreshType {
    case header
    case footer
}

public typealias RefreshBlock = () -> Void
public typealias RespectiveRefreshStatus = (RefreshStatus, Int)

/// 加载状态
public enum RefreshStatus: Int {
    /// 无
    case none = -1
    /// 开始上拉刷新
    case beginHeaderRefresh = 0
    /// 结束下拉刷新
    case endHeaderRefresh
    /// 开始上拉加载
    case beingFooterRefresh
    /// 结束上拉加载
    case endFooterRefresh
    /// 没有更多数据
    case noMoreData
    case resetNoMoreData
    case hiddenHeader
    case hiddenFooter
    case showHeader
    case showFooter
}

fileprivate enum TagType: Int {
    case `default` = 0
    case indiscrimination = -1
}

/* ==================== OutputRefreshProtocol ==================== */
// viewModel 中 output使用

private var refreshStatusKey = "refreshStatusKey"
private var refreshStatusRespectivelyKey = "refreshStatusRespectivelyKey"

public protocol RefreshControllable: class, AssociatedObjectStore, Compatible {}

public extension NameSpace where Base: RefreshControllable {
    
    /// 告诉外界的 scrollView 当前的刷新状态
    var refreshStatus : BehaviorRelay<RefreshStatus> {
        return base.associatedObject(
            forKey: &refreshStatusKey,
            default: BehaviorRelay<RefreshStatus>(value: .none))
    }
    
    /// 同 refreshStatus，但可以针对不同 scrollView 做出控制
    var refreshStatusRespective : BehaviorRelay<RespectiveRefreshStatus> {
        return base.associatedObject(
            forKey: &refreshStatusRespectivelyKey,
            default: BehaviorRelay<RespectiveRefreshStatus>(value: (.none, TagType.default.rawValue)))
    }
    
    fileprivate func autoSetRefreshStatus(header: RefreshHeader?, footer: RefreshFooter?) -> Disposable {
        return Observable.of (
                refreshStatusRespective.asObservable(),
                refreshStatus.asObservable()
                    .flatMap { Observable.just(($0, TagType.indiscrimination.rawValue)) }
            )
            .merge()
            .subscribe(onNext: { (status, tag) in
                var isHeader = true
                var isFooter = true
                if tag != TagType.indiscrimination.rawValue {
                    isHeader = tag == header?.tag ?? TagType.default.rawValue
                    isFooter = tag == footer?.tag ?? TagType.default.rawValue
                }
                switch status {
                case .beginHeaderRefresh:
                    if isHeader { header?.beginRefreshing() }
                case .endHeaderRefresh:
                    if isHeader { header?.endRefreshing() }
                case .beingFooterRefresh:
                    if isFooter { footer?.beginRefreshing() }
                case .endFooterRefresh:
                    if isFooter { footer?.endRefreshing() }
                case .noMoreData:
                    if isFooter { footer?.endRefreshingWithNoMoreData() }
                case .resetNoMoreData:
                    if isFooter { footer?.resetNoMoreData() }
                case .hiddenHeader:
                    if isHeader { header?.isHidden = true }
                case .hiddenFooter:
                    if isFooter { footer?.isHidden = true }
                case .showHeader:
                    if isHeader { header?.isHidden = false }
                case .showFooter:
                    if isFooter { footer?.isHidden = false }
                case .none: break
                }
            })
    }
}

// MARK:- Refreshable
/* ================== Refreshable ================== */
// 需要使用 「刷新功能」 时使用

// MARK: 设置默认配置
public class RefreshableConfigure: NSObject {
    static let shared = RefreshableConfigure()
    private override init() { super.init() }
    
    fileprivate var headerConfig : RefreshableHeaderConfig?
    fileprivate var footerConfig: RefreshableFooterConfig?
    
    /// 获取默认下拉配置
    ///
    /// - Returns: RefreshableHeaderConfig
    fileprivate static func defaultHeaderConfig() -> RefreshableHeaderConfig? {
        return RefreshableConfigure.shared.headerConfig
    }
    
    /// 获取默认上拉配置
    ///
    /// - Returns: RefreshableFooterConfig
    fileprivate static func defaultFooterConfig() -> RefreshableFooterConfig? {
        return RefreshableConfigure.shared.footerConfig
    }
    
    /// 设置默认上拉配置
    ///
    /// - Parameters:
    ///   - headerConfig: RefreshableHeaderConfig
    ///   - footerConfig: RefreshableFooterConfig
    public static func setDefaultConfig(headerConfig: RefreshableHeaderConfig?,
                                        footerConfig: RefreshableFooterConfig? = nil) {
        RefreshableConfigure.shared.headerConfig = headerConfig
        RefreshableConfigure.shared.footerConfig = footerConfig
    }
    
}

public protocol Refreshable: Compatible {}

public extension Reactive where Base: Refreshable {
    /// 下拉控件
    ///
    /// - Parameters:
    ///   - vm: 遵守 RefreshControllable 协议的对象
    ///   - scrollView: UIScrollView 及子类
    ///   - headerConfig: 下拉控件配置
    /// - Returns: Observable<Void>
    func headerRefresh<T: RefreshControllable>(
        _ vm: T,
        _ scrollView: UIScrollView,
        headerConfig: RefreshableHeaderConfig? = nil
    ) -> Observable<Void> {
        
        return .create { observer -> Disposable in
            vm.cc.autoSetRefreshStatus(
                header: self.base.cc.initRefreshHeader(
                        scrollView,
                        config: headerConfig)
                        { observer.onNext(()) },
                footer: nil)
        }
    }
    
    /// 上拉控件
    ///
    /// - Parameters:
    ///   - vm: 遵守 RefreshControllable 协议的对象
    ///   - scrollView: UIScrollView 及子类
    ///   - footerConfig: 上拉控件配置
    /// - Returns: Observable<Void>
    func footerRefresh<T: RefreshControllable>(
        _ vm: T,
        _ scrollView: UIScrollView,
        footerConfig: RefreshableFooterConfig? = nil
    ) -> Observable<Void> {
        
        return .create { observer -> Disposable in
            vm.cc.autoSetRefreshStatus(
                header: nil,
                footer: self.base.cc.initRefreshFooter(
                        scrollView,
                        config: footerConfig)
                        { observer.onNext(()) }
            )
        }
    }
    
    /// 上下拉控件
    ///
    /// - Parameters:
    ///   - vm: 遵守 RefreshControllable 协议的对象
    ///   - scrollView: UIScrollView 及子类
    ///   - headerConfig: 下拉控件配置
    ///   - footerConfig: 上拉控件配置
    /// - Returns: Observable<RefreshType>
    func refresh<T: RefreshControllable>(
        _ vm: T,
        _ scrollView: UIScrollView,
        headerConfig: RefreshableHeaderConfig? = nil,
        footerConfig: RefreshableFooterConfig? = nil
    ) -> Observable<RefreshType> {
        
        return Observable.create { observer -> Disposable in
            vm.cc.autoSetRefreshStatus(
                header: self.base.cc.initRefreshHeader(
                        scrollView,
                        config: headerConfig)
                        { observer.onNext(.header) },
                footer: self.base.cc.initRefreshFooter(
                        scrollView,
                        config: footerConfig)
                        { observer.onNext(.footer) }
            )
        }
    }
}

// MARK: 创建刷新控件

public extension NameSpace where Base: Refreshable {

    fileprivate func initRefreshHeader(
        _ scrollView: UIScrollView,
        config: RefreshableHeaderConfig? = nil,
        _ action: @escaping () -> Void
    ) -> RefreshHeader? {
        
        if config == nil {
            if let headerConfig = RefreshableConfigure.defaultHeaderConfig() {
                scrollView.mj_header = createRefreshHeader(scrollView, config: headerConfig, action)
            } else {
                scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: action)
            }
            scrollView.mj_header?.tag = scrollView.tag
            return scrollView.mj_header
        }
        scrollView.mj_header = createRefreshHeader(scrollView, config: config!, action)
        scrollView.mj_header?.tag = scrollView.tag
        return scrollView.mj_header
    }
    
    fileprivate func initRefreshFooter(
        _ scrollView: UIScrollView,
        config: RefreshableFooterConfig? = nil,
        _ action: @escaping RefreshBlock
    ) -> RefreshFooter? {
        
        if config == nil {
            if let footerConfig = RefreshableConfigure.defaultFooterConfig() {
                scrollView.mj_footer = createRefreshFooter(scrollView, config: footerConfig, action)
            } else {
                scrollView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: action)
            }
            scrollView.mj_footer?.tag = scrollView.tag
            return scrollView.mj_footer
        }
        
        scrollView.mj_footer = createRefreshFooter(scrollView, config: config!, action)
        scrollView.mj_footer?.tag = scrollView.tag
        return scrollView.mj_footer
    }
    
    fileprivate func createRefreshHeader(
        _ scrollView: UIScrollView,
        config: RefreshableHeaderConfig ,
        _ action: @escaping () -> Void
    ) -> RefreshHeader? {
        
        var header: MJRefreshStateHeader?
        switch config.type {
        case .normal:
            let normalHeader = MJRefreshNormalHeader(refreshingBlock: action)
            normalHeader.loadingView?.style = config.activityIndicatorViewStyle
            header = normalHeader
        case .gif:
            let gifHeader = MJRefreshGifHeader { action() }
            if config.idleImages.count > 0 {
                gifHeader.setImages(config.idleImages, for: .idle)
            }
            if config.pullingImages.count > 0 {
                gifHeader.setImages(config.pullingImages, for: .pulling)
            }
            if config.refreshingImages.count > 0 {
                gifHeader.setImages(config.refreshingImages, for: .refreshing)
            }
            header = gifHeader
        case .diy(let HeaderType):
            return HeaderType.init{ action() }
        }
        
        // title
        if config.idleTitle != nil { header?.setTitle(config.idleTitle!, for: .idle) }
        if config.pullingTitle != nil { header?.setTitle(config.pullingTitle!, for: .pulling) }
        if config.refreshingTitle != nil { header?.setTitle(config.refreshingTitle!, for: .refreshing) }
        
        // font
        if config.stateFont != nil { header?.stateLabel?.font = config.stateFont! }
        if config.lastUpdatedTimeFont != nil { header?.lastUpdatedTimeLabel?.font = config.lastUpdatedTimeFont! }
        
        // textColor
        if config.stateColor != nil { header?.stateLabel?.textColor = config.stateColor! }
        if config.lastUpdatedTimeColor != nil { header?.lastUpdatedTimeLabel?.textColor = config.lastUpdatedTimeColor! }
        
        // hide
        header?.stateLabel?.isHidden = config.hideState
        header?.lastUpdatedTimeLabel?.isHidden = config.hideLastUpdatedTime
        
        // labelLeftInset
        if config.labelLeftInset != nil { header?.labelLeftInset = config.labelLeftInset! }
        
        return header
    }
    
    fileprivate func createRefreshFooter(
        _ scrollView: UIScrollView,
        config: RefreshableFooterConfig ,
        _ action: @escaping () -> Void
    ) -> RefreshFooter? {
        
        var autoFooter : MJRefreshAutoStateFooter?
        var backFooter : MJRefreshBackStateFooter?
        
        switch config.type {
        case .autoNormal:
            let autoNormalFooter = MJRefreshAutoNormalFooter(refreshingBlock: action)
            autoNormalFooter.loadingView?.style = config.activityIndicatorViewStyle
            autoFooter = autoNormalFooter
        case .autoGif:
            let autoGifFooter = MJRefreshAutoGifFooter(refreshingBlock: action)
            if config.images.count > 0 {
                autoGifFooter.setImages(config.images, for: MJRefreshState.refreshing)
            }
            autoFooter = autoGifFooter
        case .backNormal:
            let backNormalFooter = MJRefreshBackNormalFooter(refreshingBlock: action)
            backNormalFooter.loadingView?.style = config.activityIndicatorViewStyle
            backFooter = backNormalFooter
        case .backGif:
            let backGifFooter = MJRefreshBackGifFooter(refreshingBlock: action)
            if config.images.count > 0 {
                backGifFooter.setImages(config.images, for: MJRefreshState.refreshing)
            }
            backFooter = backGifFooter
        case .diy(let FooterType):
            return FooterType.init{ action() }
        }
        
        if autoFooter != nil {
            // title
            if config.idleTitle != nil { autoFooter?.setTitle(config.idleTitle!, for: .idle) }
            if config.refreshingTitle != nil { autoFooter?.setTitle(config.refreshingTitle!, for: .refreshing) }
            if config.norMoreDataTitle != nil { autoFooter?.setTitle(config.norMoreDataTitle!, for: .noMoreData) }
            
            // font
            if config.stateFont != nil { autoFooter?.stateLabel?.font = config.stateFont! }
            
            // textColor
            if config.stateColor != nil { autoFooter?.stateLabel?.textColor = config.stateColor! }
            
            // hide
            autoFooter?.stateLabel?.isHidden = config.hideState
            
            // labelLeftInset
            if config.labelLeftInset != nil { autoFooter?.labelLeftInset = config.labelLeftInset! }
            
            return autoFooter
        } else {
            // title
            if config.idleTitle != nil { backFooter?.setTitle(config.idleTitle!, for: .idle) }
            if config.refreshingTitle != nil { backFooter?.setTitle(config.refreshingTitle!, for: .refreshing) }
            if config.norMoreDataTitle != nil { backFooter?.setTitle(config.norMoreDataTitle!, for: .noMoreData) }
            
            // font
            if config.stateFont != nil { backFooter?.stateLabel?.font = config.stateFont! }
            
            // textColor
            if config.stateColor != nil { backFooter?.stateLabel?.textColor = config.stateColor! }
            
            // hide
            backFooter?.stateLabel?.isHidden = config.hideState
            
            // labelLeftInset
            if config.labelLeftInset != nil { backFooter?.labelLeftInset = config.labelLeftInset! }
            
            return backFooter
        }
    }
}
