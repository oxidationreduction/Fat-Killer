//
//  BMI.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct BMI: View {
    @Environment(\.colorScheme) var colorScheme

    var isLight: Bool {
      colorScheme == .light
    }
    
    var bmiVal: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("BMI (身高体重指数): ")
                    .foregroundColor(isLight ? .black : .white)
                Text("\(bmiVal, specifier: "%.1f")")
                    .bold()
                    .foregroundColor(isLight ? .black : .white)
            }
            
            HStack {
                if bmiVal < 15.5 {
                    ProgressView("BMI", value: 0, total: 1)
                        .progressViewStyle(BMIStyle())
                        .frame(width: 300, height: 25, alignment: .center)
                    Text("过瘦")
                }
                else if bmiVal < 31.5 {
                    let ratio: Double = (bmiVal - 15.5) / 15.5
                    
                    ProgressView("BMI", value: ratio, total: 1)
                        .progressViewStyle(BMIStyle())
                        .frame(width: 300, height: 25, alignment: .center)
                    
                    Spacer()
                    
                    if bmiVal < 18.5 {
                        Text("偏瘦")
                            .foregroundColor(.gray)
                    }
                    else if bmiVal < 24.0 {
                        Text("正常")
                    }
                    else if bmiVal < 28.0 {
                        Text("过重")
                            .foregroundColor(.orange)
                    }
                    else {
                        Text("肥胖")
                            .foregroundColor(.red)
                    }
                }
                else {
                    ProgressView("BMI", value: 1, total: 1)
                        .progressViewStyle(BMIStyle())
                    Text("肥胖")
                }
            }
        }
    }
}

struct BMIStyle: ProgressViewStyle {
    let light: Color
    let medium: Color
    let heavy: Color
    let ultraHeavy: Color
    let pointer: Color
    init(light: Color = .init(CGColor(gray: 0.68, alpha: 1)), medium: Color = .green, heavy: Color = .yellow, ultraHeavy: Color = .init(CGColor(red: 245.0/255.0, green: 121.0/255.0, blue: 1.0/255.0, alpha: 1.0)), pointer: Color = .red){
        self.light = light
        self.medium = medium
        self.heavy = heavy
        self.ultraHeavy = ultraHeavy
        self.pointer = pointer
    }
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader{ proxy in
            ZStack {
                ZStack(alignment:.topLeading){
                    ultraHeavy
                    
                    Rectangle()
                        .fill(heavy)
                        .frame(width: proxy.size.width * CGFloat(0.806))
                    
                    Rectangle()
                        .fill(medium)
                        .frame(width: proxy.size.width * CGFloat(0.548))
                    
                    Rectangle()
                        .fill(light)
                        .frame(width: proxy.size.width * CGFloat(0.194))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                RoundedRectangle(cornerRadius: 40)
                    .fill(pointer)
                    .scaleEffect(x: 0.02, y: 1.2)
                    .offset(x: proxy.size.width * CGFloat((configuration.fractionCompleted ?? 0.0) - 0.5))
            }
        }
    }
}
