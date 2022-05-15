//
//  TrendDetail.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/25.
//

import SwiftUI

struct TrendDetail: View {
    //@EnvironmentObject var modelData: ModelData
    let data: [WeightSample]
    
    var minWeight: Double {
        var ans: Double = 362
        for i in 0..<data.count {
            if ans > data[i].weight {
                ans = data[i].weight
            }
        }
        return ans
    }
    
    var maxWeight: Double {
        var ans: Double = 0
        for i in 0..<data.count {
            if ans < data[i].weight {
                ans = data[i].weight
            }
        }
        return ans
    }
    
    let lineColor: Color
    
    var body: some View {
         GeometryReader { proxy in
            VStack {
                HStack {
                    Path { path in
                        let width = min(proxy.size.width, proxy.size.height) * 0.9
                        let height = width * 0.75
                        
                        path.move(to: CGPoint(x: getX(data: data, index: 0, width: width), y: getY(data: data, maxWeight: maxWeight, minWeight: minWeight, index: 0, height: height)))
                        
                        for i in 1..<data.count {
                            path.addLine(to: CGPoint(x: getX(data: data, index: i, width: width), y: getY(data: data, maxWeight: maxWeight, minWeight: minWeight, index: i, height: height)))
                        }
                    }
                    .stroke(lineColor, lineWidth: 2)
                    
                    VStack {
                        Text("\(maxWeight, specifier: "%.2f")kg")
                            .font(.footnote)
                        
                        Spacer()
                        
                        if data.count > 2 {
                            Text("\((maxWeight + minWeight) / 2, specifier: "%.2f")kg")
                                .font(.footnote)
                            
                            Spacer()
                        }
            
                        Text("\(minWeight, specifier: "%.2f")kg")
                            .font(.footnote)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
        }
    }
}

func getX(data: [WeightSample], index: Int, width: CGFloat) -> CGFloat {
    let range: Double = timeInterval(startDate: data[0].sampleTime, endDate: data.last?.sampleTime ?? Date())
    
    let interval = timeInterval(startDate: Date().addingTimeInterval(-range), endDate: data[index].sampleTime)
    
    return CGFloat(interval / range) * width
}

func getY(data: [WeightSample], maxWeight: Double, minWeight: Double, index: Int, height: CGFloat) -> CGFloat {
    let interval: Double = data[index].weight - minWeight
    
    if maxWeight != minWeight {
        return height - CGFloat(interval / (maxWeight - minWeight)) * height
    } else {
        return height / 2
    }
}

func timeInterval(startDate: Date, endDate: Date) -> Double {
    return endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
}
