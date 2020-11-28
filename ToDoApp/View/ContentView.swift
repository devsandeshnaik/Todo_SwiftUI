//
//  ContentView.swift
//  ToDoApp
//
//  Created by Sandesh on 18/11/20.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    
    @EnvironmentObject var iconSettings: IconName
    
    @State private var showingSettingsView = false
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - No todos
                List {
                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(_colorize(priority: todo.priority ?? "Normal"))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2),lineWidth: 0.75))
                        }.padding(.vertical, 10 )
                    } //END: ForEach
                    .onDelete(perform: deleteTodo)
                } //END: List
                .listStyle(PlainListStyle())
                if todos.count == 0 {
                    EmptyListView()
                }
            }
            //END: ZStack
            .navigationBarTitle("Todo", displayMode: .inline)
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button(action: {
                        showingSettingsView.toggle()
                    }, label: {
                        Image(systemName: "paintbrush")
                    })
            )
            .sheet(isPresented: $showingSettingsView, content: {
                SettingsView()
                    .environmentObject(self.iconSettings)
            })
        }//END: NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .overlay(
            ZStack {
                Group {
                    Circle()
                        .fill(themes[self.theme.themeSettings].themeColor)
                        .frame(width: 68, height: 68, alignment: .center)
                        .opacity(self.animatingButton ?  0.2 : 0)
                        .scaleEffect(self.animatingButton ? 1 : 0.10)
                    
                    Circle()
                        .fill(themes[self.theme.themeSettings].themeColor)
                        .frame(width: 88, height: 88, alignment: .center)
                        .opacity(self.animatingButton ? 0.15 : 0)
                        .scaleEffect(self.animatingButton ? 1 : 0.10)
                }
                .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                
                Button(action: {
                    self.showingAddTodoView.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        .background(Circle().fill(Color("ColorBase")))
                        .frame(width: 48, height: 48, alignment: .center)
                }
            }//END: ZStack
            .onAppear(perform: {
                self.animatingButton.toggle()
            })
            .padding(.bottom, 15)
            .padding(.trailing, 15)
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $showingAddTodoView) {
            AddTodoView()
                .environment(\.managedObjectContext, moc)
        }
        
        
    }
    
    // MARK: - Functions
    private func deleteTodo(at offSets: IndexSet) {
        for index in offSets {
            let todo = todos[index]
            moc.delete(todo)
            try? moc.save()
        }
    }
    
    private func _colorize(priority: String) -> Color {
        switch priority {
        case "High": return .pink
        case "Normal": return .green
        case "Low": return .blue
        default: return .gray
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        ContentView()
            .environment(\.managedObjectContext, context)
    }
}
