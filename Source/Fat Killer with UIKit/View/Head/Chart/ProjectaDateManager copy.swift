//
//  ProjectManage.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct ProjectDateManager: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("减重计划进度")
            
            HStack(alignment: .center, spacing: 0) {
                let completion: Double = modelData.timeCompletion()
                
                ProgressView("减重计划进度", value: (completion > 1) ? 1 : completion, total: 1)
                    .progressViewStyle(ProjectManagerStyle())
                    .frame(width: 300, height: 25, alignment: .center)
                
                Spacer()
                
                Text(" \(completion * 100, specifier: "%.1f")%")
            }
        }
    }
}

func datesRange(from: Date, to: Date) -> [Date] {
    if from > to { return [Date]() }

    var tempDate = from
    var array = [tempDate]

    while tempDate < to {
        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        array.append(tempDate)
    }

    return array
}
