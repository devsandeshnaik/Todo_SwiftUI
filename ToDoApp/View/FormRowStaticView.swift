//
//  FormRowStaticView.swift
//  ToDoApp
//
//  Created by Sandesh on 25/11/20.
//

import SwiftUI

struct FormRowStaticView: View {
    
    var icon: String
    var firstText: String
    var secondText: String
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .fill(Color.gray)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            Text(firstText)
                .foregroundColor(.gray)
            Spacer()
            Text(secondText)
        }
    }
}

struct FormRowStaticView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
            .previewLayout(.fixed(width: 375, height:  60))
    }
}
