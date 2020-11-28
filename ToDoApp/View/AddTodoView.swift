//
//  AddTodoView.swift
//  ToDoApp
//
//  Created by Sandesh on 18/11/20.
//

import SwiftUI
import CoreData

struct AddTodoView: View {
    
    // MARK: - Properties
    @State private var name = ""
    @State private var priority = "Normal"
    @State private var errorShowing = false
    @State private var errorTitle = ""
    @State private var errormessage = ""
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    let priorities = ["High", "Normal", "Low"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Todo Name
                    TextField("Todo: ", text: $name)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    Picker("Prority", selection: $priority) {
                        ForEach(priorities, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button(action: {
                        if name != "" {
                            let todo = Todo(context: moc)
                            todo.name = name
                            todo.priority =  priority
                            try? moc.save()
                            print("New todo \(todo.name ?? ""), priority: \(todo.priority ?? "")")
                        } else {
                            self.errorShowing = true
                            self.errorTitle = "Inavalid Name"
                            self.errormessage = "Make sure you have added some title for your new todo item"
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("SAVE")
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .padding()
                            .frame(minWidth: 0, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(themes[theme.themeSettings].themeColor)
                            .cornerRadius(9)
                            .foregroundColor(.white)
                    })
                }//END: VStack
                .padding(.horizontal)
                .padding(.vertical)
                Spacer()
            } //END: VStack
            .navigationBarTitle("New Todo", displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                    })
            )
            .alert(isPresented: $errorShowing) {
                Alert(title:  Text(errorTitle), message: Text(errormessage), dismissButton: .default(Text("OK")))
            }
        } //END: NavigationView
        .accentColor(themes[theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .previewDevice("iPhone 11")
    }
}
