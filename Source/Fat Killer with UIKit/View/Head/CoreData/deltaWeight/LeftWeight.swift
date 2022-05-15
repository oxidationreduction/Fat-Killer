//
//  LostWeight.swift
//  Fat Killer
//
//  Created by 刘洪宇 on 2021/8/19.
//

import SwiftUI

struct LeftWeight: View {
    @Environment(\.colorScheme) var colorScheme
    var isLight: Bool {
      colorScheme == .light
    }
    
    var leftWeight: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("您还需减重")
                    .font(.title)
                    .foregroundColor(isLight ? .black : .white)
                
                Spacer()
            }
            .padding()
            
            HStack(alignment: .bottom) {
                if leftWeight <= 0 {
                    Text("0.00")
                        .fontWeight(.black)
                        .font(.custom("Title", size: 100))
                        .foregroundColor(.green)
                }
                else {
                    Text("\(leftWeight, specifier: "%.2f")")
                        .fontWeight(.black)
                        .foregroundColor(.red)
                        .font(.custom("Title", size: 100))
                }
                
                VStack {
                    Text("kg")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor((leftWeight <= 0) ? .green : .red)
                }
                .padding(.bottom)
            }
        }
        .padding(.leading)
        .padding(.trailing)
    }
}
