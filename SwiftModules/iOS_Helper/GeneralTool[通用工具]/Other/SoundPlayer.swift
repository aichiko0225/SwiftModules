//
//  SoundPlayer.swift
//  NewEnergy
//
//  Created by 陈文轩 on 2019/5/16.
//  Copyright © 2019 com.ssi. All rights reserved.
//

import Foundation
import AVKit

public struct SoundPlayer {
    
    
    /// 播放简单音效
    ///
    /// - Parameters:
    ///   - fileName: 文件名
    ///   - isAlert: 是否震动
    static func playSound(fileName: String, isAlert: Bool = false) {
        // 一. 获取 SystemSoundID
        //   参数1: 文件路径
        //   参数2: SystemSoundID, 指针
        guard let audioUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else { return }
        
        let urlCF = audioUrl as CFURL
        var systemSoundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(urlCF, &systemSoundID)
        // 二. 开始播放
        if isAlert {
            // 3. 带振动播放, 可以监听播放完成(模拟器不行)
            AudioServicesPlayAlertSound(systemSoundID)
        }else {
            // 3. 不带振动播放, 可以监听播放完成
            AudioServicesPlaySystemSound(systemSoundID)
        }
        
    }
    
    /// 震动
    static func systemVibration() {
        //建立的SystemSoundID对象
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        //振动
        AudioServicesPlaySystemSound(soundID)
    }
    
}
