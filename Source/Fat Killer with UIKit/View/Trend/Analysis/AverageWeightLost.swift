//
//  AverageWeightLost.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/25.
//

import SwiftUI

struct AverageWeightLost: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if modelData.profile.weight >= modelData.project.startWeight {
                    Text("计划开始以来")
                        .foregroundColor(.red)
                        .padding(5)
                    
                    Text("平均每天")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("减重")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("0.00kg")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .bold()
                } else {
                    Text("计划开始以来")
                        .foregroundColor(.green)
                        .padding(5)
                    
                    Text("平均每天")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("减重")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                        .bold()
                    Text("\((modelData.project.startWeight - modelData.profile.weight)*86400/Date().timeIntervalSince(modelData.project.startDate), specifier: "%.2f")kg")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                }
            }
            if modelData.profile.weight >= modelData.project.startWeight {
                Color.red.frame(width: 160, height: 200, alignment: .center)
                    .zIndex(1)
                    .opacity(0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            } else {
                Color.green.frame(width: 160, height: 200, alignment: .center)
                    .zIndex(1)
                    .opacity(0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        }
    }
}
