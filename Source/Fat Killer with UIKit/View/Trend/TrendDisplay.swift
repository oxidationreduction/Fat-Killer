//
//  TrendDisplay.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct TrendDisplay: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 40)
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(modelData.project.title)")
                            .bold()
                            .font(.largeTitle)
                        Text("开始于\(date2Word(date: modelData.project.startDate))")
                    }
                    
                    Spacer()
                }
                .padding()
                
                PageView(pages: modelData.options.map {
                    SingleTrend(option: $0)
                })
                Spacer()
                    .frame(height: 230)
            }
            VStack {
                Spacer()
                
                HStack {
                    AverageWeightLost()
                        .environmentObject(modelData)
                    Spacer()
                        .frame(width: 35)
                    TimeEstimate()
                        .environmentObject(modelData)
                }
                .padding()
                
                Divider()
                
                HStack {
                    Text("*数据仅供参考")
                        .font(.footnote)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 3

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PageViewController(pages: pages, currentPage: $currentPage)
            VStack {
                PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                    .frame(width: CGFloat(pages.count * 18))
                    .padding(.leading)
                
                Spacer()
                    .frame(height: 80)
            }
        }
    }
}
