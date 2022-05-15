//
//  Profile.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/20.
//

import Foundation
import SwiftUI
import HealthKit

final class ModelData: ObservableObject {
    @Published var project: Project = emptyProject          //计划
    @Published var profile: Profile = emptyProfile          //用户信息
    @Published var cmpData: CompareData = CompareData()     //体重变化量
    @Published var weights: [WeightSample] = []     //存储系统中记录的所有体重样本
    @Published var notification: notification = emptyNotification
    
    var options: [String] = ["week", "month", "project", "year", "all"]
                                                    //用于“趋势”模块选择时间范围
    
    var weekSamples: [WeightSample] {
        weights.filter { sample in
            Date().timeIntervalSince(sample.sampleTime) < 86400 * 7
        }
    }       //存储近一周内的体重样本
    var monthSamples: [WeightSample] {
        weights.filter { sample in
            Date().timeIntervalSince(sample.sampleTime) < 86400 * 30
        }
    }       //存储近30天内的体重样本
    var yearSamples: [WeightSample] {
        weights.filter { sample in
            Date().timeIntervalSince(sample.sampleTime) < 86400 * 365
        }
    }         //存储最近365天内的体重样本
    var projectSamples: [WeightSample] {
        weights.filter { sample in
            Date().timeIntervalSince(sample.sampleTime) < Date().timeIntervalSince(project.startDate)
        }
    }     //存储自计划开始以来的体重样本
    
    func lostWeight() -> Double {
        return profile.weight - project.startWeight
    }           //返回已减掉的体重
    func leftWeight() -> Double {
        return profile.weight - project.targetWeight
    }           //返回还需减掉的体重
    func weightCompletion() -> Double {
        return -lostWeight() / project.targetLost
    }       //返回减肥计划完成率
    func timeCompletion() -> Double {
        let lostTime: Double = Date().timeIntervalSince1970 - project.startDate.timeIntervalSince1970
        let totalTime: Double = project.dueDate.timeIntervalSince1970 - project.startDate.timeIntervalSince1970
        return lostTime / totalTime
    }          //返回计划时间进度
    func deltaWeight(order: String) -> Double {
        if order == "day" {
            return profile.weight - cmpData.preDaysWeight
        } else if order == "week" {
            return profile.weight - cmpData.preWeekWeight
        } else if order == "month" {
            return profile.weight - cmpData.preMonthWeight
        } else {
            print("Profile-ModelData-deltaweight(): order error.")
            return 1e9
        }
    }
                                        //按照option返回不同时间段内的体重变化值
}

class WeightSample {
    var weight: Double = 0          //样本体重
    var sampleTime: Date = Date()   //样本创建时间
}

class Profile: NSObject, NSCoding {
    //编码
    func encode(with coder: NSCoder) {
        coder.encode(self.height, forKey: "height")
        coder.encode(self.weight, forKey: "weight")
        coder.encode(self.BMI, forKey: "BMI")
    }
    //解码
    required init?(coder: NSCoder) {
        self.height = coder.decodeObject(forKey: "height") as? Double ?? 0
        self.weight = coder.decodeObject(forKey: "weight") as? Double ?? 0
    }
    
    var height: Double
    var weight: Double
    
    var BMI: Double {
        if (height > 0 && weight > 0) {
            return weight / height / height
        } else {
            return 0
        }
    }           //身高体重指数
    var lessWeight: Double {
        if (height > 0) {
            return height * height * 18.5
        } else {
            return 0
        }
    }    //健康状态下的体重最低值推荐限度
    var bestWeight: Double {
        if height > 0 {
            return height * height * 21.25
        } else {
            return 0
        }
    }    //最佳体重
    var maxWeight: Double {
        if height > 0 {
            return height * height * 24
        } else {
            return 0
        }
    }     //健康状态下的体重最高值推荐限度
    
    init(height: Double, weight: Double) {
        self.height = height
        self.weight = weight
    }
}

let emptyProfile = Profile(height: 0, weight: 0)

class Project: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.dueDate, forKey: "dueDate")
        coder.encode(self.startDate, forKey: "startDate")
        coder.encode(self.startWeight, forKey: "startWeight")
        coder.encode(self.height, forKey: "height")
        coder.encode(self.targetWeight_string, forKey: "targetWeight_string")
        coder.encode(self.quote, forKey: "quote")
        coder.encode(self.quoteSource, forKey: "quoteSource")
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.dueDate = coder.decodeObject(forKey: "dueDate") as? Date ?? Date()
        self.startDate = coder.decodeObject(forKey: "startDate") as? Date ?? Date()
        self.startWeight = coder.decodeObject(forKey: "startWeight") as? Double ?? 0
        self.height = coder.decodeObject(forKey: "height") as? Double ?? 0
        self.targetWeight_string = coder.decodeObject(forKey: "targetWeight_string") as? String ?? ""
        self.quote = coder.decodeObject(forKey: "quote") as? String ?? baseQuote
        self.quoteSource = coder.decodeObject(forKey: "quoteSource") as? String ?? baseQuoteSource
    }
    
    var title: String                   //计划名称
    var dueDate: Date                   //计划截止日期
    var startDate: Date                 //计划开始日期
    var startWeight: Double             //计划开始时用户的体重
    var height: Double                  //用户身高
    var targetWeight_string: String     //临时变量，用于存储用户输入的目标体重字符串
    var quote: String = baseQuote       //用户想要在主页上展示的文字
    var quoteSource: String = baseQuoteSource   //展示的文字的来源
    
    var targetWeight: Double {
        if targetWeight_string == "" {
            return 0
        } else {
            return atof(targetWeight_string)
        }
    }   //用户目标体重
    var targetLost: Double {
        if (startWeight > 0 && targetWeight > 0) {
            return startWeight - targetWeight
        } else {
            return 0
        }
    }       //完成本计划用户需要减掉的体重
    var BMI: Double {
        if (targetWeight > 0 && height > 0) {
            return targetWeight / height / height
        } else {
            return 0
        }
    }               //用户目标体重对应的身高体重指数
    
    init(title: String, dueDate: Date, startDate: Date, startWeight: Double, height: Double, targetWeight_string: String, quote: String, quoteSource: String) {
        self.title = title
        self.dueDate = dueDate
        self.startDate = startDate
        self.startWeight = startWeight
        self.height = height
        self.targetWeight_string = targetWeight_string
        self.quote = quote
        self.quoteSource = quoteSource
    }
}

let emptyProject: Project = Project(title: "", dueDate: Date(), startDate: Date(), startWeight: 0, height: 0,
                                    targetWeight_string: "", quote: baseQuote, quoteSource: baseQuoteSource)

class notification: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(self.notiStatus, forKey: "notiStatus")
        coder.encode(self.notiTime, forKey: "notiTime")
    }
    
    required init?(coder: NSCoder) {
        self.notiStatus = coder.decodeBool(forKey: "notiStatus")
        self.notiTime = coder.decodeObject(forKey: "notiTime") as? Date ?? Date()
    }
    
    var notiStatus: Bool
    var notiTime: Date
    
    init(notiStatus: Bool, notiTime: Date) {
        self.notiStatus = notiStatus
        self.notiTime = notiTime
    }
}

let emptyNotification = notification(notiStatus: false, notiTime: Date())

let baseQuote: String = "“说‘下次再做’的人是蠢蛋，说‘明天再做’的人也是蠢蛋，老想着‘还有明天’会吃到苦头的。”"
let baseQuoteSource: String = "日剧《求婚大作战》"

class CompareData: NSObject {
    var isDayAcquired: Bool = false
    var preDaysWeight: Double = 0
    var preDaysWeightTime: Date = Date()
    
    var isWeekAcquired: Bool = false
    var preWeekWeight: Double = 0
    var preWeekWeightTime: Date = Date()
    
    var isMonthAcquired: Bool = false
    var preMonthWeight: Double = 0
    var preMonthWeightTime: Date = Date()
    
    var preDaysWeightInterval: Int {
        return checkDateDiff(tempDate: preDaysWeightTime, option: "day")
    }
    
    var preWeekWeightInterVal: Int {
        return checkDateDiff(tempDate: preWeekWeightTime, option: "week")
    }
    
    var preMonthWeightInterval: Int {
        return checkDateDiff(tempDate: preMonthWeightTime, option: "month")
    }
}

func calTimeInterval(interval: Double, tempTime: Date, dueTime: Date) -> Int {
    if tempTime > Date() {
        return 0
    } else {
        var ans: Int = 0
        
        repeat {
            ans += 1
        } while tempTime.addingTimeInterval(interval*Double(ans)) < Date()
        
        return ans
    }
}

func checkDateDiff(tempDate: Date, option: String) -> Int {
    let formatter = DateFormatter()
    let calendar = Calendar.current
    formatter.dateFormat = "yyyy-MM-dd"

    let startDate = formatter.date(from: formatter.string(from: tempDate))

    let endDate = formatter.date(from: formatter.string(from: Date()))
    
    if option == "day" {
        let diff:DateComponents = calendar.dateComponents([.day], from: startDate!, to: endDate!)
        return (diff.day! <= 0) ? 1 : diff.day!
    } else if option == "week" {
        let diff:DateComponents = calendar.dateComponents([.yearForWeekOfYear], from: startDate!, to: endDate!)
        return (diff.yearForWeekOfYear! <= 0) ? 1 : diff.yearForWeekOfYear!
    } else if option == "month" {
        let diff:DateComponents = calendar.dateComponents([.month], from: startDate!, to: endDate!)
        return (diff.month! <= 0) ? 1 : diff.month!
    } else if option == "year" {
        let diff:DateComponents = calendar.dateComponents([.year], from: startDate!, to: endDate!)
        return (diff.year! <= 0) ? 1 : diff.year!
    } else {
        print("Profile-checkDateDiff: Invalid option")
        return 0
    }
}
