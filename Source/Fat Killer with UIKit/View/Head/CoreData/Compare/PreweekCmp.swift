//
//  PreweekCompare.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct PreweekCmp: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if modelData.cmpData.preWeekWeight != 0 {
                    if modelData.deltaWeight(order: "week") > 0 {
                        Text("比\(modelData.cmpData.preWeekWeightInterVal)周前")
                            .foregroundColor(.red)
                        
                        Text("重\(modelData.deltaWeight(order: "week"), specifier: "%.2f")kg")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .font(.title)
                    } else if modelData.deltaWeight(order: "week") == 0 {
                        Text("比\(modelData.cmpData.preWeekWeightInterVal)周前")
                            .foregroundColor(.blue)
                        
                        Text("重0.00kg")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .font(.title)
                    } else {
                        Text("比\(modelData.cmpData.preWeekWeightInterVal)周前")
                            .foregroundColor(.green)
                        
                        Text("轻\(-modelData.deltaWeight(order: "week"), specifier: "%.2f")kg")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .font(.title)
                    }
                } else {
                    Text("上周")
                        .foregroundColor(.blue)
                    
                    Text("无数据")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
            
            if modelData.cmpData.preWeekWeight != 0 {
                if modelData.deltaWeight(order: "week") > 0 {
                    Color.red.frame(width: 150, height: 95, alignment: .center)
                        .zIndex(1)
                        .opacity(0.15)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else if modelData.deltaWeight(order: "week") == 0 {
                    Color.blue.frame(width: 150, height: 95, alignment: .center)
                        .zIndex(1)
                        .opacity(0.15)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Color.green.frame(width: 150, height: 95, alignment: .center)
                        .zIndex(1)
                        .opacity(0.15)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            } else {
                Color.blue.frame(width: 150, height: 95, alignment: .center)
                    .zIndex(1)
                    .opacity(0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}
