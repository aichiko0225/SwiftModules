//
//  AppPermissionService.swift
//  SwiftModules
//
//  Created by 赵光飞 on 2020/8/28.
//

import Foundation
import Photos
import AVFoundation

/// App 权限服务
public struct AppPermissionService {
    static let shared = AppPermissionService()
    
    private init() {}
    
    /// 相册
    public func checkPhotoLibraryPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:  //用户尚未做出选择
            return false
        case .authorized:  //已授权
            return true
        case .denied:  //用户拒绝
            return false
        case .restricted:  //家长控制
            return false
        default:
            return false
        }
    }
    
    //相机
    public func checkCameraPermission() -> Bool {
        let mediaType = AVMediaType.video
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch authorizationStatus {
        case .notDetermined:  //第一次使用，用户尚未做出选择。(这里返回true 是为了在第一次时提示用户选择)
            return false
        case .authorized:  //已授权
            return true
        case .denied:  //用户拒绝
            return false
        case .restricted:  //家长控制
            return false
            default:
            return false
        }
    }
    
    //定位
    public func checkLocationPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:  //用户尚未做出选择
            return false
        case .restricted:  //未被授权
            return false
        case .denied:  //用户拒绝
            return false
        case .authorizedWhenInUse:  //使用期间定位
            return true
        case .authorizedAlways:  //一直定位
            return true
        default:
            return false
        }
    }
    
    //麦克风
    public func checkMicroPermission() -> Bool {
        let mediaType = AVMediaType.audio
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch authorizationStatus {
        case .notDetermined:  //用户尚未做出选择
            return false
        case .authorized:  //已授权
            return true
        case .denied:  //用户拒绝
            return false
        case .restricted:  //家长控制
            return false
        default:
            return false
        }
    }
    
}
