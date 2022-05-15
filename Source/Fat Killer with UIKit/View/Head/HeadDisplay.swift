//
//  SwiftUIView.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct HeadDisplay: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var showingProfile = false
    @State private var showingLostWeight = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            
            Button(action: {
                showingLostWeight.toggle()
            }) {
                if showingLostWeight {
                    LostWeight(lostWeight: finalModelData.lostWeight())
                } else {
                    LeftWeight(leftWeight: finalModelData.leftWeight())
                }
            }
            
            
            CmpManager()
                .environmentObject(modelData)
            
            VStack {
                if showingLostWeight {
                    Tip(lostWeight: finalModelData.lostWeight())
                } else {
                    estimate(leftWeight: finalModelData.leftWeight())
                    //LeftWeight(lostWeight: lostWeight, targetLost: targetLost)
                }
            }
            .padding(.trailing)
            
            Divider()
            
            VStack {
                ProjectManager()
                    .environmentObject(modelData)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.top)
                
                Divider()
                
                ProjectDateManager()
                    .environmentObject(modelData)
                    .padding(.leading)
                    .padding(.trailing)
                
                Divider()
                    
                Button(action: { showingProfile.toggle() }) {
                    BMI(bmiVal: finalModelData.profile.BMI)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom)
                }
                .sheet(isPresented: $showingProfile) {
                    BMI_info()
                }
            }
            .frame(height: 220)

            Divider()
            
            if showingLostWeight && modelData.lostWeight() < 0 {
                Text("*数据仅供娱乐。需要指出的是，您减掉的\(-finalModelData.lostWeight(), specifier: "%.2f")kg 体重并不全是脂肪，还包括大量的水。")
                    .frame(height: 40)
                    .font(.footnote)
                    .padding()
            } else {
                Quote()
                    .environmentObject(modelData)
            }
        }
    }
}
