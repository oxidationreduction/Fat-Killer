//
//  Tip.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct estimate: View {
    var leftWeight: Double
    
    var body: some View {
        if leftWeight > 0 {
            VStack(alignment: .leading) {
                Text("特别提醒：")
                    .font(.footnote)
                
                Text("    请注意按照身体状况选择减脂方式，避免挑战高强度运动。")
                    .font(.footnote)
                
            }
            .frame(height: 40)
            .padding()
        }
        else {
            VStack(alignment: .leading) {
                Text("恭喜你🎉")
                    .font(.footnote)
                
                Text("    您的减重计划已完成，享受轻盈的身体吧！")
                    .font(.footnote)
            }
            .frame(height: 40)
            .padding()
        }
    }
}
