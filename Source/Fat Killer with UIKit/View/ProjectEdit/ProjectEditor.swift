//
//  ProjectEditor.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/22.
//

import SwiftUI
import HealthKit
import UserNotifications

var firstEdit: Bool = false

var titleStatus: Bool = true
var targetStatus: Bool = true
var weightStatus: Bool = true

struct ProjectEditor: View {
    @Binding var noti: notification
    @Binding var project: Project
    @Binding var isEditing: Bool
    @Binding var alert1Present: Bool
    var customLessWeight: Double
    @Binding var tempWeight_string: String
    @Binding var displayHelper: Bool
    @Binding var cmpData: CompareData
    
    let profile: Profile
    let preProject: Project
    
    var body: some View {
        VStack {
            HStack {
//                Button (action: {
//                    project = preProject
//
//                    titleStatus = true
//                    targetStatus = true
//                    weightStatus = true
//
//                    isEditing = false
//                    editorActive = false
//
//                    UIApplication.shared.keyWindow?.endEditing(true)
//                }) {
//                    Text("取消")
//                        .padding()
//                }
//
                Spacer()
                
                Button (action: {
                    project.height = profile.height
                    
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    if noti.notiStatus {
                        addNotification()
                    }
                    
                    if ((firstEdit)
                     || (!firstEdit
                     && project.BMI >= 18.5)
                     && project.targetWeight <= 361
                     && project.title != ""
                     && project.dueDate != Date()
                     && judgeTempWeight()){
                        
                        loadDataBeforeClose()
                        
                    } else {
                        alert1Present = true
                    }
                    
                }) {
                    Text("完成")
                        .padding()
                }
                .alert(isPresented: $alert1Present) {
                    if (((firstEdit
                      && project.targetWeight <= 25)
                      || (!firstEdit
                      && project.BMI < 18.5))
                      && project.title != "") {
                        targetStatus = false
                        return Alert(title: Text("您设置的目标体重过轻"),
                                     message: Text("可能导致身体异常，确定设置吗？"),
                                     primaryButton: .destructive(Text("仍然设置"), action: {
                                        loadDataBeforeClose()
                                     }),
                                     secondaryButton: .cancel(Text("去修改")))
                    } else {
                        if project.targetWeight > 361 || project.targetWeight < 25 {
                            targetStatus = false
                        }
                        if project.title == "" {
                            titleStatus = false
                        }
                        weightStatus = judgeTempWeight()
                        return Alert(title: Text("您输入的数据有问题"), message: Text("请重新检查。"))
                    }
                }
            }
            
            HStack {
                Text("编辑计划或记录体重!")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            .padding()
            
            HStack {
                VStack {
                    HStack {
                        Text("计划名称")
                            .font(.title3)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 5)
                        
                        TextField("请输入计划名称", text: $project.title)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(titleStatus ? Color.gray : Color.red)
                            .frame(width: 383, height: 35)
                    )
                }
                
            }
            .padding(.leading)
            .padding(.trailing)
            
            HStack {
                Text("目标体重")
                    .font(.title3)
                Spacer()
                
                TextField("请输入", text: $project.targetWeight_string)
                    .keyboardType(UIKeyboardType.decimalPad)
                    .padding(8)
                    .frame(width: 80, alignment: .trailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(targetStatus ? Color.gray : Color.red)
                            .frame(height: 35)
                    )
            }
            .padding()
            
            HStack {
                Text("计划开始日期")
                    .font(.title3)
                
                Spacer()
                
                DatePicker("", selection: $project.startDate, in: ...Date(), displayedComponents: .date)
                    .padding(8)
                    .frame(width: 80)
                
                Spacer()
                    .frame(width: 20)
            }
            .padding(.leading)
            .padding(.trailing)
            
            HStack {
                Text("预计完成日期")
                    .font(.title3)
                
                Spacer()
                
                DatePicker("", selection: $project.dueDate, in: Date().addingTimeInterval(86400)..., displayedComponents: .date)
                    .padding(8)
                    .frame(width: 80)
                    //.scaleEffect(0.75)
                
                Spacer()
                    .frame(width: 20)
            }
            .padding(.leading)
            .padding(.trailing)
            
            HStack {
                Text("当前您的体重")
                    .font(.title3)
                
                Spacer()
                
                TextField("可不填", text: $tempWeight_string)
                    .keyboardType(UIKeyboardType.decimalPad)
                    .padding(8)
                    .foregroundColor(.gray)
                    .frame(width: 80, alignment: .trailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(weightStatus ? Color.gray : Color.red)
                            .frame(height: 35)
                    )
            }
            .padding()
            
            Toggle(isOn: $noti.notiStatus) {
                Text("定时提醒")
                    .font(.title3)
            }
            .padding(.leading)
            .padding(.trailing)
            //.padding(.top)
            
            HStack {
                Text("定时提醒时间")
                    .font(.title3)
                
                Spacer()
                
                DatePicker("", selection: $noti.notiTime, displayedComponents: .hourAndMinute)
                    .padding(8)
                    .frame(width: 80)
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
            
            if displayHelper {
                Spacer()
                VStack(alignment: .leading) {
                    if profile.BMI >= 18.5 && profile.BMI < 24 {
                        Text("*您的体重处于标准状态，不需要进行大规模的减脂计划。您的理想体重约为\(profile.bestWeight, specifier: "%.2f") kg。")
                            .font(.footnote)
                            .padding(.bottom)
                        Text("**如您确需减脂，请确保目标体重不低于\(profile.lessWeight, specifier: "%.2f")kg。")
                            .font(.footnote)
                    } else if profile.BMI < 18.5 {
                        Text("*您的体重过轻，不适合进行大规模的减脂计划。您的理想体重约为\(profile.bestWeight, specifier: "%.2f") kg。")
                            .font(.footnote)
                        Text("**标准状况下，亚洲成年人的BMI应当不低于18.5，这意味着您的体重应当不低于\(profile.lessWeight, specifier: "%.2f")kg。")
                            .font(.footnote)
                    } else {
                        Text("*您的理想体重约为\(profile.bestWeight, specifier: "%.2f") kg。")
                            .font(.footnote)
                        Text("**标准状况下，亚洲成年人的BMI应当不高于24，这意味着您的体重应当不高于\(profile.maxWeight, specifier: "%.2f")kg。")
                            .font(.footnote)
                    }
                }
                .padding()
                
                Spacer()
                    .frame(height: 45)
            } else {
                Spacer()
            }
        }
    }
    
    func judgeTempWeight() -> Bool {
        if tempWeight_string == "" {
            return true
        } else {
            let tempWeight = atof(tempWeight_string)
            return tempWeight >= 25 && tempWeight < 361
        }
    }
    
    func addNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("ProjectEditor-addNotification: Notification Authorized.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "该记录体重了!"
        content.subtitle = "快来称称体重，看看你的计划完成得如何"
        content.sound = UNNotificationSound.default
        
        var matchingDate = DateComponents()
        matchingDate.hour = noti.notiTime.hour
        matchingDate.minute = noti.notiTime.minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: matchingDate, repeats: true)

        // 选择一个随机标识符
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // 添加我们的通知请求
        UNUserNotificationCenter.current().add(request)
    }
    
    func loadDataBeforeClose() {
        finalModelData.project.title = project.title
        finalModelData.project.dueDate = project.dueDate
        finalModelData.project.targetWeight_string = project.targetWeight_string
        finalModelData.project.startDate = project.startDate
        
        UIApplication.shared.keyWindow?.endEditing(true)
        
        loadStartWeight()
        loadPreDaysWeight()
        loadPreWeekWeight()
        loadPreMonthWeight()
        loadWeightSeries()
        
        if tempWeight_string != "" {
            let tempWeight: Double = atof(tempWeight_string)
            
            profile.weight = tempWeight
            finalModelData.profile.weight = tempWeight
        }
        
        editorActive = false
        isEditing = false
        targetStatus = true
        titleStatus = true
        weightStatus = true
    }
    
    private func loadStartWeight() {
        loadSingleWeight(startDate: project.startDate.addingTimeInterval(-86400),
                         endDate: Date(), ascending: true)
        
        if !weightSampleAcquired {
            loadSingleWeight(startDate: Date.distantPast,
                             endDate: project.startDate.addingTimeInterval(86400),
                             ascending: false)
        }
    }
    
    private func loadSingleWeight(startDate: Date, endDate: Date, ascending: Bool) {
        //想要获取的样本类型
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        //调用查询函数
        ProfileDataStore.getSingleSample(for: weightSampleType,
                                         startDate: startDate,
                                         endDate: endDate,
                                         ascending: ascending) { (sample, error) in
            //检查是否获取到了数据
            guard let sample = sample else {
                return
            }
            //转换为浮点值并存储
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            project.startWeight = weightInKg
            finalModelData.project.startWeight = weightInKg
            //报告已经获取到了数据，应用程序的其他部分会做出响应
            weightSampleAcquired = true
        }
    }
    
    private func loadAndDisplayMostRecentWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
            
        ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in
            guard let sample = sample else {
                return
            }
          
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            project.startWeight = weightInKg
        }
    }
    
    private func loadPreDaysWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        ProfileDataStore.getSingleSample(for: weightSampleType,
                                         startDate: Date().addingTimeInterval(-86400 * 7),
                                         endDate: Date().addingTimeInterval(-86000),
                                         ascending: false) { (sample, error) in
              
            guard let sample = sample else {
                return
            }
          
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            cmpData.preDaysWeight = weightInKg
            cmpData.preDaysWeightTime = sample.startDate
            cmpData.isDayAcquired = true
            
            finalModelData.cmpData.isDayAcquired = true
            finalModelData.cmpData.preDaysWeight = weightInKg
            finalModelData.cmpData.preDaysWeightTime = sample.startDate
        }
    }
    
    private func loadPreWeekWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        ProfileDataStore.getSingleSample(for: weightSampleType,
                                         startDate: Date().addingTimeInterval(-86400 * 14.5),
                                         endDate: Date().addingTimeInterval(-86400 * 7 + 1),
                                         ascending: false) { (sample, error) in
              
            guard let sample = sample else {
                return
            }
          
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            cmpData.preWeekWeight = weightInKg
            cmpData.preWeekWeightTime = sample.startDate
            cmpData.isWeekAcquired = true
            
            finalModelData.cmpData.isWeekAcquired = true
            finalModelData.cmpData.preWeekWeight = weightInKg
            finalModelData.cmpData.preWeekWeightTime = sample.startDate
        }
    }
    
    private func loadPreMonthWeight() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        ProfileDataStore.getSingleSample(for: weightSampleType,
                                         startDate: Date().addingTimeInterval(-86400 * 365),
                                         endDate: Date().addingTimeInterval(-86400 * 30),
                                         ascending: false) { (sample, error) in
              
            guard let sample = sample else {
                return
            }
          
            let weightInKg = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            cmpData.preMonthWeight = weightInKg
            cmpData.preMonthWeightTime = sample.startDate
            cmpData.isMonthAcquired = true
            
            finalModelData.cmpData.isMonthAcquired = true
            finalModelData.cmpData.preMonthWeight = weightInKg
            finalModelData.cmpData.preMonthWeightTime = sample.startDate
        }
    }
    
    private func loadWeightSeries() {
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        ProfileDataStore.getSeriesSample(for: weightSampleType,
                                         startDate: Date.distantPast,
                                         endDate: Date(),
                                         ascending: true) { (Sample, error) in
            guard let sample = Sample else {
                return
            }
            print("ProjectEditor-loadWeightSeries(): finalModelData.weights.count = \(finalModelData.weights.count)\n")
        }
    }
}
