//
//  ProjectManage.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct ProjectManager: View {
    var lostWeight: Double
    var targetLost: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("减重计划完成度")
            
            HStack(alignment: .center, spacing: 0) {
                let completion: Double = 0 - (lostWeight / targetLost)
                
                ProgressView("减重计划完成度", value: completion, total: 1)
                    .progressViewStyle(ProjectManagerStyle())
                    .frame(width: 300, height: 25, alignment: .center)
                
                Spacer()
                
                Text(" \(completion * 100, specifier: "%.1f")%")
            }
        }
        //.padding()
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

struct ProjectManager_Previews: PreviewProvider {
    static var previews: some View {
        ProjectManager(lostWeight: -2, targetLost: -24)
    }
}
