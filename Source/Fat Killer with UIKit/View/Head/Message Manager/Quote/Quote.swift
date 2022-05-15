//
//  Quote.swift
//  Fat Killer with UIKit
//
//  Created by 刘洪宇 on 2021/8/25.
//

import SwiftUI

struct Quote: View {
    @Environment(\.colorScheme) var colorScheme
    var isLight: Bool {
      colorScheme == .light
    }
    
    @EnvironmentObject var modelData: ModelData
    
    @State var draftProject = emptyProject
    @State var isQuoteEditing = false
    @State var quoteAlertPresent = false
    
    var body: some View {
        Button (action: {
            isQuoteEditing = true
        }) {
            VStack {
                Text(modelData.project.quote)
                    .font(.footnote)
                    .foregroundColor(isLight ? .black : .white)
                    .frame(height: 34)
                
                if modelData.project.quoteSource != "" {
                    HStack {
                        Spacer()
                        Text("————\(modelData.project.quoteSource)")
                            .foregroundColor(isLight ? .black : .white)
                            .font(.footnote)
                    }
                    .padding(.trailing)
                }
            }
            .frame(height: 40)
            .padding()
        }
        .sheet(isPresented: $isQuoteEditing) {
            QuoteEditor(project: $draftProject, isQuoteEditing: $isQuoteEditing, quoteAlertPresent: $quoteAlertPresent, preProject: modelData.project)
                .onAppear {
                    draftProject = modelData.project
                }
                .onDisappear {
                    modelData.project = draftProject
                    finalModelData.project = draftProject
                    
                    UserDefaults().saveCustomObj(draftProject, key: "curProject")
                }
        }
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
        myTextView.font = UIFont(name: "HelveticaNeue", size: 20)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}
