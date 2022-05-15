//
//  ProjectManage.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct ProjectManager: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.colorScheme) var colorScheme
    var isLight: Bool {
      colorScheme == .light
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("减重计划完成度")
            
            HStack(alignment: .center, spacing: 0) {
                let completion: Double = modelData.weightCompletion()
                
                if completion >= 0 && completion <= 1{
                    ProgressView("减重计划完成度", value: completion, total: 1)
                        .progressViewStyle(ProjectManagerStyle())
                        .frame(width: 300, height: 25, alignment: .center)
                } else if completion < 0 {
                    ProgressView("减重计划完成度", value: 0, total: 1)
                        .progressViewStyle(ProjectManagerStyle())
                        .frame(width: 300, height: 25, alignment: .center)
                } else {
                    ProgressView("减重计划完成度", value: 1, total: 1)
                        .progressViewStyle(ProjectManagerStyle())
                        .frame(width: 300, height: 25, alignment: .center)
                }

                Spacer()
                
                if completion < 0 {
                    Text(" \(completion * 100, specifier: "%.1f")%")
                        .foregroundColor(.red)
                } else if completion >= 1 {
                    Text(" \(completion * 100, specifier: "%.1f")%")
                        .foregroundColor(.green)
                } else {
                    if isLight {
                        Text(" \(completion * 100, specifier: "%.1f")%")
                            .foregroundColor(.black)
                    } else {
                        Text(" \(completion * 100, specifier: "%.1f")%")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct ProjectManagerStyle: ProgressViewStyle{
    let foregroundColor: Color
    let backgroundColor: Color
    let pointer: Color
    init(foregroundColor: Color = .blue, backgroundColor: Color = .yellow, pointer: Color = .red){
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.pointer = pointer
    }
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader{ proxy in
            ZStack(alignment: .topLeading){
                backgroundColor
                
                Rectangle()
                    .fill(foregroundColor)
                    .frame(width: proxy.size.width * CGFloat(configuration.fractionCompleted ?? 0.0))
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            RoundedRectangle(cornerRadius: 40)
                .fill(pointer)
                .scaleEffect(x: 0.02, y: 1.2)
                .offset(x: proxy.size.width * CGFloat((configuration.fractionCompleted ?? 0.0) - 0.5))
                .shadow(radius: 10)
        }
    }
}
