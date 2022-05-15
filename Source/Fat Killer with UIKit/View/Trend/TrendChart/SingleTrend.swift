//
//  SingleTrend.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/26.
//

import SwiftUI

struct SingleTrend: View {
    @EnvironmentObject var modelData: ModelData
    
    var option: String
    var data: [WeightSample] {
        if option == "week" {
            return modelData.weekSamples
        } else if option == "month" {
            return modelData.monthSamples
        } else if option == "project" {
            return modelData.yearSamples
        } else if option == "year" {
            return modelData.projectSamples
        } else if option == "all" {
            return modelData.weights
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            if option == "week" {
                Text("7天以内")
                    .font(.title3)
                    .bold()
            } else if option == "month" {
                Text("30天内")
                    .font(.title3)
                    .bold()
            } else if option == "project" {
                Text("一年之内")
                    .font(.title3)
                    .bold()
            } else if option == "year" {
                Text("自计划开始后")
                    .font(.title3)
                    .bold()
            } else if option == "all" {
                Text("所有体重数据")
                    .font(.title3)
                    .bold()
            }
            
            if data.count < 2 {
                if data.count == 0 {
                    Text("无数据")
                } else {
                    Text("\(date2Word(date: data[0].sampleTime))，体重\(data[0].weight)kg。")
                }
                HStack {
                    Spacer()
                    Text("数据过少")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
            } else {
                let (correlation, k): (Double, Double) = analysis(data: data)
                
                if abs(correlation) < 0.8 {
                    Text("您的体重不稳定")
                    TrendDetail(data: data, lineColor: .blue)
                        .environmentObject(modelData)
                        .padding()
                } else {
                    if k > 0.05 {
                        Text("您的体重正在增长")
                        TrendDetail(data: data, lineColor: .red)
                            .environmentObject(modelData)
                            .padding()
                    } else if k < -0.05 {
                        Text("您的体重正在下降")
                        TrendDetail(data: data, lineColor: .green)
                            .environmentObject(modelData)
                            .padding()
                    } else {
                        Text("您的体重较为平稳")
                        TrendDetail(data: data, lineColor: .blue)
                            .environmentObject(modelData)
                            .padding()
                    }
                }
            }
        }
        .frame(width: 400)
        .padding()
    }
}

func analysis(data: [WeightSample]) -> (correlation: Double, k: Double) {
    var timeSeries: [Double] = []
    var weightSum: Double = 0
    var timeSum: Double = 0
    for i in 0..<data.count {
        weightSum += data[i].weight
        timeSeries.append(timeInterval(startDate: data[0].sampleTime, endDate: data[i].sampleTime))
        timeSum += timeSeries[i]
    }
    let weightAve: Double = weightSum / Double(data.count)
    let timeAve: Double = timeSum / Double(data.count)

    var upper: Double = 0
    var lower1: Double = 0
    var lower2: Double = 0
    
    for i in 0..<data.count {
        upper += (data[i].weight - weightAve) * (timeSeries[i] - timeAve) / 86400
        lower2 += (data[i].weight - weightAve) * (data[i].weight - weightAve)
        lower1 += (timeSeries[i] - timeAve) * (timeSeries[i] - timeAve) / 86400 / 86400
    }
    
    var correlation: Double = 0
    let k: Double = upper / lower1
    
    if lower1 != 0 {
        correlation = upper / sqrt(lower1 * lower2)
    }
    
    return (correlation, k)
}
