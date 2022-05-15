//
//  Tip.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct Tip: View {
    var lostWeight: Double
    
    var body: some View {
        if lostWeight < 0 {
            VStack(alignment: .leading) {
                Text("冷知识：")
                    .font(.footnote)
                
                if lostWeight > -5 {
                    let bananaNum: Double = -lostWeight * 96
                    Text("    \(-lostWeight, specifier: "%.2f")kg 脂肪所含的能量，与\(bananaNum, specifier: "%.f")根中等大小的香蕉相近。*")
                        .font(.footnote)
                        .frame(height: 34)
                }
                else if lostWeight > -10 {
                    let hamNum: Double = -lostWeight * 14
                    Text("    \(-lostWeight, specifier: "%.2f")kg 脂肪所含的能量，与\(hamNum, specifier: "%.f")个巨无霸汉堡相近。*")
                        .font(.footnote)
                        .frame(height: 34)
                }
                else {
                    let waterMass: Double = -lostWeight * 32.231 / 4.21 / 75.0
                    Text("    \(-lostWeight, specifier: "%.2f")kg 脂肪所含的能量，能够将约\(waterMass, specifier: "%.2f")吨室温下的水烧开。*")
                        .font(.footnote)
                        .frame(height: 34)
                }
            }
            .frame(height: 40)
            .padding()
        } else {
            VStack(alignment: .leading) {
                Text("你难道想要放任你的体重不减反增吗？")
                    .font(.footnote)
                
                Text("“你这个肥宅啊，才立完flag几天，就废了，真是太逊了。”")
                    .font(.footnote)
            }
            .frame(height: 40)
            .padding()
        }
    }
}
