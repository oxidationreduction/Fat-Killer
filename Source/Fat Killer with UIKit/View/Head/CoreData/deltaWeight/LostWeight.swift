//
//  LostWeight.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct LostWeight: View {
    @Environment(\.colorScheme) var colorScheme
    var isLight: Bool {
      colorScheme == .light
    }
    
    var lostWeight: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("您已经减重")
                    .font(.title)
                    .foregroundColor(isLight ? .black : .white)
                
                Spacer()
            }
            .padding()
            
            HStack(alignment: .bottom) {
                if lostWeight < 0 {
                    Text("\(-lostWeight, specifier: "%.2f")")
                        .fontWeight(.black)
                        .font(.custom("Title", size: 100))
                        .foregroundColor(.green)
                }
                else {
                    Text("0.00")
                        .fontWeight(.black)
                        .font(.custom("Title", size: 100))
                        .foregroundColor(.red)
                }
                
                VStack {
                    Text("kg")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor((lostWeight < 0) ? .green : nil)
                }
                .padding(.bottom)
            }
        }
        .padding(.leading)
        .padding(.trailing)
    }
}
