//
//  ContentView.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI
import HealthKit
import UIKit

var finalModelData: ModelData = ModelData()

struct ContentView: View {
    @State private var selection: Tab = .profile
    
    @EnvironmentObject var modelData: ModelData
    
    enum Tab {
        case headDisplay
        case trend
        case profile
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                HeadDisplay()
                    .environmentObject(modelData)
                    .tabItem {
                        Label("总览", systemImage: "star")
                    }
                    .tag(Tab.headDisplay)
                    

                TrendDisplay()
                    .environmentObject(modelData)
                    .tabItem {
                        Label("趋势", systemImage: "chart.bar")
                    }
                    .tag(Tab.trend)

                curProject()
                    .environmentObject(modelData)
                    .tabItem {
                        Label("计划", systemImage: "sparkles")
                    }
                    .tag(Tab.profile)
            }
        }
    }
}
