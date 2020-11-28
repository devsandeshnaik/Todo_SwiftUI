//
//  EmptyListView.swift
//  ToDoApp
//
//  Created by Sandesh on 21/11/20.
//

import SwiftUI

struct EmptyListView: View {
    
    @State private var isAnimated = false
    let images = [
         "illustration-no1",
                  "illustration-no2",
                  "illustration-no3"]
    
    let tips = [
        "Use your time wisely",
        "Slow and Steady wins the race",
        "Keep it short and sweet",
        "Put hard task first",
        "Reward your self after work",
        "Collects task ahead of time",
        "Each night schedule for tomorrow"
    ]
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(images.randomElement() ?? images[0])
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 256,
                       idealWidth: 280,
                       maxWidth: 360,
                       minHeight: 256,
                       idealHeight: 280,
                       maxHeight: 360,
                       alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .layoutPriority(1)
                .foregroundColor(themes[self.theme.themeSettings].themeColor)
    
            Text(tips.randomElement() ?? tips[0])
                .layoutPriority(0.5)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(themes[self.theme.themeSettings].themeColor)
        }
        .padding(.horizontal)
        .opacity(isAnimated ? 1 : 0)
        .offset(y: isAnimated ? 0 : -50)
        .animation(.easeOut(duration: 1.5))
        .frame(minWidth: 0, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            self.isAnimated = true
        })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
            .preferredColorScheme(.dark)
    }
}
