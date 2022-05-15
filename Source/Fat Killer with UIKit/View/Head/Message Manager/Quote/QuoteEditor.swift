//
//  QuoteEditor.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/25.
//

import SwiftUI

struct QuoteEditor: View {
    @Binding var project: Project
    @Binding var isQuoteEditing: Bool
    @Binding var quoteAlertPresent: Bool
    
    let preProject: Project
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button (action: {
                    if project.quote != "" {
                        isQuoteEditing = false
                    } else {
                        quoteAlertPresent = true
                    }
                    UIApplication.shared.keyWindow?.endEditing(true)
                }) {
                    Text("完成")
                        .padding()
                }
                .alert(isPresented: $quoteAlertPresent) {
                    return Alert(title: Text("您未输入句子"),
                                 message: Text("句子不能为空"),
                                 dismissButton: .default(Text("去修改")))
                }
            }
            Spacer()
            HStack {
                VStack {
                    HStack {
                        Text("输入你想在主页上显示的句子")
                            .font(.title3)
                        
                        Spacer()
                    }
                    HStack {
                        Spacer()
                            .frame(width: 5)
                        
                        TextView(text: $project.quote)
                            .frame(height: 85)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(!quoteAlertPresent ? Color.gray : Color.red)
                            .frame(width: 383, height: 90)
                    )
                }
            }
            .padding()
            HStack {
                VStack {
                    HStack {
                        Text("输入句子的来源")
                            .font(.title3)
                        
                        Spacer()
                    }
                    HStack {
                        Spacer()
                            .frame(width: 5)
                        TextField("请输入", text: $project.quoteSource)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(!quoteAlertPresent ? Color.gray : Color.red)
                            .frame(width: 383, height: 35)
                    )
                }
            }
            .padding()
            Spacer()
        }
    }
}
