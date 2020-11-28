//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Sandesh on 25/11/20.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconsSettings: IconName
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                Form {
                    
                    Section(header: Text("Choose the app icon")) {
                        Picker(selection: $iconsSettings.currentIndex, label:
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 9,style: .continuous)
                                            .strokeBorder(Color.primary,lineWidth: 2)
                                        
                                        Image(systemName: "paintbrush")
                                            .font(.system(size: 28, weight: .regular, design: .default))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: 44, height: 44)
                                    
                                    Text("App Icons".uppercased())
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.primary)
                                }
                               , content: {
                            ForEach(0 ..< iconsSettings.iconsNames.count) { index  in
                                HStack {
                                    Image(uiImage: UIImage(named: self.iconsSettings.iconsNames[index]) ?? UIImage())
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(8)
                                    
                                    Spacer().frame(width:8)
                                    
                                    Text(self.iconsSettings.iconsNames[index])
                                        .frame(alignment: .leading)
                                    
                                }
                                .padding(3)
                            }
                        })
                        .onReceive([self.iconsSettings.currentIndex].publisher.first(), perform: { value in
                            let index = self.iconsSettings.iconsNames.firstIndex(of: UIApplication.shared.alternateIconName ?? "Blue") ?? 0
                            
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconsSettings.iconsNames[value]) { error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("Success")
                                    }
                                }
                            }
                        })
                    }
                    .padding(.vertical, 3)
                    
                    Section(header : HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(themes[theme.themeSettings].themeColor)
                    }) {
                        List {
                            ForEach(themes) { item in
                                Button(action: {
                                    theme.themeSettings = item.id
                                }) {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        Text(item.themeName)
                                    }
                                }.accentColor(Color.primary)
                            }
                        }
                    }
                    .padding(.vertical, 3)
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: .blue, text: "Twitter", link: "https://twitter.com/devsandesh")
                        FormRowLinkView(icon: "play.rectangle", color : .green, text: "Courses", link: "https://www.udemy.com/user/robert-petras")
                    }
                    .padding(.vertical, 3)
                    
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatability", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Sandesh")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Albert Roca")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.1")
                    }
                    .padding(.vertical, 3)
                }
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                Text("Copyright © All rights reserved, \n devsandesh.in")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(Color("ColorBackground")
            .edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(themes[theme.themeSettings].themeColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(IconName())
    }
}
