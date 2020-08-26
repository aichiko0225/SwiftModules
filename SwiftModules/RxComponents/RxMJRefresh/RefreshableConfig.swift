//
//  RefreshableConfig.swift
//  SwiftModules
//
//  Created by ash on 2020/8/25.
//

import Foundation
import MJRefresh

// MARK:- RefreshableConfig

/* ================== RefreshableConfig ================== */
// Header & Footer「DIY」Configure

public enum RefreshHeaderType {
    case normal
    case gif
    case diy(type: MJRefreshHeader.Type)
}

public enum RefreshFooterType {
    case autoNormal
    case autoGif
    case backNormal
    case backGif
    case diy(type: MJRefreshFooter.Type)
}

public struct RefreshableHeaderConfig {
    /// 当type为diy时，其它属性就不用再传递了
    var type : RefreshHeaderType = .normal
    
    // title
    var idleTitle : String? = nil // Pull down to refresh
    var pullingTitle : String? = nil // Release to refresh
    var refreshingTitle : String? = nil // Loading ...
    
    // font
    var stateFont : UIFont? = nil
    var lastUpdatedTimeFont : UIFont? = nil
    
    // textColor
    var stateColor : UIColor? = nil
    var lastUpdatedTimeColor : UIColor? = nil
    
    // hide
    var hideState = false
    var hideLastUpdatedTime = false
    
    /** 文字距离圈圈、箭头的距离 */
    var labelLeftInset: CGFloat?
    
    // normal type
    var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray
    
    // gif type images
    var idleImages: [UIImage] = []
    var pullingImages: [UIImage] = []
    var refreshingImages: [UIImage] = []
    
    public init(
        type: RefreshHeaderType = .normal,
        idleTitle: String? = nil,
        pullingTitle: String? = nil,
        refreshingTitle: String? = nil,
        stateFont: UIFont? = nil,
        lastUpdatedTimeFont: UIFont? = nil,
        stateColor: UIColor? = nil,
        lastUpdatedTimeColor: UIColor? = nil,
        hideState: Bool = false,
        hideLastUpdatedTime: Bool = false,
        labelLeftInset: CGFloat? = nil,
        activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray,
        idleImages: [UIImage] = [],
        pullingImages: [UIImage] = [],
        refreshingImages: [UIImage] = []
    ) {
        self.type = type
        self.idleTitle = idleTitle
        self.pullingTitle = pullingTitle
        self.refreshingTitle = refreshingTitle
        self.stateFont = stateFont
        self.lastUpdatedTimeFont = lastUpdatedTimeFont
        self.stateColor = stateColor
        self.lastUpdatedTimeColor = lastUpdatedTimeColor
        self.hideState = hideState
        self.hideLastUpdatedTime = hideLastUpdatedTime
        self.labelLeftInset = labelLeftInset
        self.activityIndicatorViewStyle = activityIndicatorViewStyle
        self.idleImages = idleImages
        self.pullingImages = pullingImages
        self.refreshingImages = refreshingImages
    }
}

public struct RefreshableFooterConfig {
    /// 当type为diy时，其它属性就不用再传递了
    var type : RefreshFooterType = .autoNormal
    
    // title
    var idleTitle : String? = nil // Click or drag up to refresh
    var refreshingTitle : String? = nil // Loading more ...
    var norMoreDataTitle : String? = nil // No more data
    
    // font
    var stateFont : UIFont? = nil
    
    // textColor
    var stateColor : UIColor? = nil
    
    // hide
    var hideState = false
    
    /** 文字距离圈圈、箭头的距离 */
    var labelLeftInset: CGFloat?
    
    // normal type
    var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray
    
    // gif type images
    var images: [UIImage] = []
    
    public init(
        type: RefreshFooterType = .autoNormal,
        idleTitle: String? = nil,
        refreshingTitle: String? = nil,
        norMoreDataTitle: String? = nil,
        stateFont: UIFont? = nil,
        stateColor: UIColor? = nil,
        hideState: Bool = false,
        labelLeftInset: CGFloat? = nil,
        activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray,
        images: [UIImage] = []
    ) {
        self.type = type
        self.idleTitle = idleTitle
        self.refreshingTitle = refreshingTitle
        self.norMoreDataTitle = norMoreDataTitle
        self.stateFont = stateFont
        self.stateColor = stateColor
        self.hideState = hideState
        self.labelLeftInset = labelLeftInset
        self.activityIndicatorViewStyle = activityIndicatorViewStyle
        self.images = images
    }
}

