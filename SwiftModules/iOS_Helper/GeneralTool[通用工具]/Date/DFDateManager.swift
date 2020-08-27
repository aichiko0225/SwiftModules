//
//  DFDateManager.swift
//  DFCV
//
//  Created by 王立 on 2018/2/7.
//  Copyright © 2018年 南斗六星. All rights reserved.
//

import Foundation

public class DFDateManager: NSObject {
    
    //MARK :获取时间字符串
    class func getDateStr(_ date: Date,_ formatterStr: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        return formatter.string(from: date)
    }
    
    /// 根据字符串获取时间
    class func getDate(_ dateStr: String,_ formatterStr: String = "yyyy-MM-dd HH:mm:ss") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        return formatter.date(from: dateStr) ?? Date()
    }
    
    //MARK :转换时间字符串格式
    class func getNewFormatterStr(_ dateStr:String, _ oldFormatter:String,_ newFormatter:String) -> String {
        
        let date = getDate(dateStr, oldFormatter)
        return getDateStr(date,newFormatter)
    }
    
    //MARK :获取月份的第一天
    class func getFirstDateForMonth(_ byDate: Date) -> Date {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([Calendar.Component.year,Calendar.Component.month], from: byDate)
        return calendar.date(from: dateComponent)!
    }
    //MARK :获取对应的date是周几
    class func getWeekNum(_ date :Date) -> Int {
        return Calendar.current.ordinality(of: Calendar.Component.day, in: Calendar.Component.weekOfMonth, for: date)!
    }
    //MARK :判断两个date所属月份是不是相同的
    class func checkSameMoth(_ date1 :Date,_ date2:Date) -> Bool {
        let component1 = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month], from: date1)
        let component2 = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month], from: date2)
        return component1.year == component2.year && component1.month == component2.month
    }
    //MARK :获取对应的date所在月份的行数
    class func getRowNumFor(_ date :Date) -> Int {
        let firstDate = getFirstDateForMonth(date)
        let xingqi = Calendar.current.ordinality(of: Calendar.Component.day, in: Calendar.Component.weekOfMonth, for: date)
        let daysOfMonth = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: firstDate)
        let shengyu = (daysOfMonth?.count)! - (8 - xingqi!)
        return shengyu % 7 > 0 ? shengyu/7 + 2 : shengyu/7 + 1
    }
    //MARK :获取上一个月的时间
    class func getForwardMonthDate(_ date :Date) -> Date {
        var comps = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: date)
        let year = comps.year
        let month = comps.month
        let day = comps.day
        var finalDate = date
        if day! <= 28 || month! == 1 {
            comps.month! -= 1
            finalDate = Calendar.current.date(from: comps)!
        }else{
            let dateFormat = DateFormatter()
            let dateStr = String.init(format: "%ld-%ld-3", year!,month!)
            dateFormat.dateFormat = "yy-MM-dd";
            let theMonth = dateFormat.date(from: dateStr)
            let range = Calendar.current .range(of: Calendar.Component.day, in: Calendar.Component.month, for: theMonth!)
            let dayInMonth = range?.count
            let finalDateStr = String.init(format: "%ld-%ld-%ld", year!,month!-1,min(day!, dayInMonth!))
            finalDate = dateFormat.date(from: finalDateStr)!
        }
        return finalDate
    }
    //MARK :获取 下一个月的时间
    class func getNextMonthDate(_ date :Date) -> Date {
        var comps = Calendar.current.dateComponents([Calendar.Component.year,Calendar.Component.month,Calendar.Component.day], from: date)
        let year = comps.year
        let month = comps.month
        let day = comps.day
        var finalDate = date
        if day! <= 28 || month! == 12 {
            comps.month! += 1
            finalDate = Calendar.current.date(from: comps)!
        }else{
            let dateFormat = DateFormatter()
            let dateStr = String.init(format: "%ld-%ld-3", year!,month!)
            dateFormat.dateFormat = "yy-MM-dd";
            let theMonth = dateFormat.date(from: dateStr)
            let range = Calendar.current .range(of: Calendar.Component.day, in: Calendar.Component.month, for: theMonth!)
            let dayInMonth = range?.count
            let finalDateStr = String.init(format: "%ld-%ld-%ld", year!,month!+1,min(day!, dayInMonth!))
            finalDate = dateFormat.date(from: finalDateStr)!
        }
        return finalDate
    }
    
    //计算指定日期所在月的天数
    class func getDaysInMonth(with date: Date) -> Int {
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: date) {
            return range.count
        }
        return 30
    }
    
    // 把时间戳转换为date
    class func getDateFromTimeStamp(_ timeStamp: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
    }
    
    // 把时间戳转换为时间字符串
    class func getDateStrFromTimeStamp(_ timeStamp: Int, dateFormatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = self.getDateFromTimeStamp(timeStamp)
        return getDateStr(date, dateFormatter)
    }
}



