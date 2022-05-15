//
//  CmpManager.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct CmpManager: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack(alignment: .center, spacing: -25) {
            
            PredayCmp()
                .environmentObject(modelData)
                .scaleEffect(0.7)
            
            PreweekCmp()
                .environmentObject(modelData)
                .scaleEffect(0.7)
            
            PremonthCmp()
                .environmentObject(modelData)
                .scaleEffect(0.7)
        }
    }
}
