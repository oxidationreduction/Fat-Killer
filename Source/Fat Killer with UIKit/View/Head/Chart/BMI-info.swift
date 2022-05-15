//
//  BMI-info.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct BMI_info: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("BMI 是什么")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            .padding(.bottom)
            
            Text("        身高体重指数（Body Mass Index）是体脂指标，它基于身高和体重进行计算，可反映出您的体重是否偏轻、正常、偏重或肥胖。它还有助于评估体脂增加可能诱发的疾病风险。")
                .padding()
            
            Text("        身高体重指数的计算方法为：您体重的千克数除以米制单位下身高的平方数。比如，一个1.9m高，85kg重的成年人，他的BMI值约为23.55。")
                .padding()
            
            Text("        亚洲成年人身高体重指数的标准值范围为18.5～24，低于18.5为体重偏轻，高于24但不高于28为超重，高于28为肥胖。本应用按照BMI值对您的减重目标设置作出指导。")
                .padding()
        }
        .padding()
    }
}
