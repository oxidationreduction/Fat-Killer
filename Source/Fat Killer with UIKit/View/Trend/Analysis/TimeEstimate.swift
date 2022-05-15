//
//  TimeEstimate.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/25.
//

import SwiftUI

struct TimeEstimate: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        let aveWeightLost = (modelData.project.startWeight - modelData.profile.weight)*86400/Date().timeIntervalSince(modelData.project.startDate)
        let timeLeft: Double = (modelData.profile.weight - modelData.project.targetWeight) / aveWeightLost
        
        ZStack {
            VStack(alignment: .leading) {
                if aveWeightLost < 0 || timeLeft > 90 {
                    Text("预计*")
                        .foregroundColor(.red)
                        .padding(5)
                    Text("剩余时间")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .bold()
                    Text("不少于")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .bold()
                    Text("100天")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .bold()
                    
                } else {
                    Text("预计*")
                        .foregroundColor(.blue)
                        .padding(5)
                    Text("剩余时间")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .bold()
                    Text("不大于")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .bold()
                    Text("\(timeLeft + 10, specifier: "%.0f")天")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .bold()
                }
            }
            if aveWeightLost < 0 || timeLeft > 90 {
                Color.red.frame(width: 160, height: 200, alignment: .center)
                    .zIndex(1)
                    .opacity(0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            } else {
                Color.blue.frame(width: 160, height: 200, alignment: .center)
                    .zIndex(1)
                    .opacity(0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        }
    }
}
