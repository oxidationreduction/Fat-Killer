//
//  ProjectEdit.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI
import HealthKit
import UserNotifications

var editorActive: Bool = true
var weightSampleAcquired: Bool = false

struct curProject: View {
    @State var isEditing: Bool = editorActive
    @State var alert1Present: Bool = false
    
    @EnvironmentObject var modelData: ModelData
    @State var draftProject = emptyProject
    @State var draftNoti = emptyNotification
    //displayHelper: Show targetWeight guidance
    @State var displayHelper: Bool = false
    
    @State var tempWeight_string: String = ""
    
    @State var cmpData: CompareData = CompareData()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 40)
                HStack {
                    Text(modelData.project.title)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                
                HStack {
                    Text("计划开始时间")
                    
                    Spacer()
                    
                    Text(/*"\(formatter.string(from: modelData.project.startDate))"*/date2Word(date: modelData.project.startDate))
                }
                .padding()
                
                HStack {
                    Text("预计完成日期")
                    
                    Spacer()
                    
                    Text(date2Word(date: modelData.project.dueDate))
                }
                .padding()
                
                HStack {
                    Text("计划开始时您的体重")
                    
                    Spacer()
                    
                    Text("\(modelData.project.startWeight, specifier: "%.2f") kg")
                }
                .padding()
                
                HStack {
                    Text("当前体重")
                    
                    Spacer()
                    
                    Text("\( modelData.profile.weight, specifier: "%.2f") kg")
                }
                .padding()
                
                HStack {
                    Text("目标体重")
                    
                    Spacer()
                    
                    Text("\(modelData.project.targetWeight, specifier: "%.2f") kg")
                }
                .padding()
                
                HStack {
                    Text("提醒体重记录")
                    
                    Spacer()
                    
                    Text(modelData.notification.notiStatus ? "每天"+getHoursAndMinutes(date: modelData.notification.notiTime) : "关闭")
                }
                .padding()
                
                Spacer()
                
                Button (action: {
                    isEditing.toggle()
                    editorActive.toggle()
                }) {
                    ZStack {
                        Color.blue.frame(width: 250, height: 95, alignment: .center)
                            .zIndex(1)
                            .opacity(0.25)
                            .cornerRadius(30)
                        Text("编辑计划").bold()
                            .font(.system(size: 40, design: .rounded))
                            .shadow(radius: 1)
                    }
                    .scaleEffect(0.75)
                }
                .padding(.bottom)
                
                
            }
            .padding()
            .sheet(isPresented: $isEditing) {
                ProjectEditor(noti: $draftNoti,
                              project: $draftProject,
                              isEditing: $isEditing,
                              alert1Present: $alert1Present,
                              customLessWeight: finalModelData.profile.lessWeight,
                              tempWeight_string: $tempWeight_string,
                              displayHelper: $displayHelper,
                              cmpData: $cmpData,
                              profile: modelData.profile,
                              preProject: finalModelData.project)
                    
                    .environmentObject(modelData)
                    .onAppear {
                        draftProject = modelData.project
                        draftProject.height = modelData.profile.height
                        draftNoti = modelData.notification
                        
                        finalModelData.project = modelData.project
                        finalModelData.project.height = modelData.profile.height
                        finalModelData.notification = modelData.notification
                    }
                    .onDisappear {
                        draftProject.height = modelData.profile.height
                        modelData.project = draftProject
                        
                        modelData.notification = draftNoti
                        
                        finalModelData.project = draftProject
                        finalModelData.project.height = modelData.profile.height
                        
                        if tempWeight_string != "" {
                            let BMI_val: Double = finalModelData.profile.BMI
                            ProfileDataStore.saveBodyMassIndexSample(BMI: BMI_val, date: Date())
                            
                            let weight_val: Double = finalModelData.profile.weight
                            ProfileDataStore.saveBodyMassSample(weight: weight_val,
                                                                date: Date())
                            
                            tempWeight_string = ""
                        }
                        
                        modelData.cmpData = cmpData
                        modelData.weights = finalModelData.weights
                        UserDefaults().saveCustomObj(draftProject, key: "curProject")
                        UserDefaults().saveCustomObj(draftNoti, key: "notification")
                        displayHelper = true
                    }
            }
        }
    }
}

struct curProject_Previews: PreviewProvider {
    static var previews: some View {
        curProject()
            .environmentObject(ModelData())
    }
}

func getHoursAndMinutes(date: Date) -> String {
    let dateFomatter = DateFormatter()
    dateFomatter.dateFormat = "HH:mm"
    return dateFomatter.string(from: date)
}

extension UserDefaults {
    ///存储自定义对象：
    func saveCustomObj(_ obj: NSCoding, key: String){
     
        let encodedObj = NSKeyedArchiver.archivedData(withRootObject: obj)
        set(encodedObj, forKey: key)
       
        synchronize()
      
    }
    ///获取自定义对象：
    func getCustomObj(for key: String) -> Any? {
        
        guard let decodedObj = object(forKey: key) as? Data else{
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: decodedObj)
    }
    ///存储基本数据类型
    func saveBasic(_ value: Any?, for key: String) {
        set(value, forKey: key)
        synchronize()
    }
}
