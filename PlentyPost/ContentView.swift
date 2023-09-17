//
//  ContentView.swift
//  PlentyPost
//
//  Created by Abdelrahman Salah on 13/09/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//struct ContentView: View {
//    @StateObject var coordinator = Coordinator()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                coordinator.currentView // This will display the current view
//
//                Spacer()
//
//                NavigationLink("Navigate to View 1", destination: View1(coordinator: coordinator))
//
//                NavigationLink("Navigate to View 2", destination: View2(coordinator: coordinator))
//            }
//        }
//    }
//}
//
//struct View1: View {
//    @ObservedObject var coordinator: Coordinator
//
//    var body: some View {
//        Text("View 1")
//            .onTapGesture {
//                coordinator.navigateToView2()
//            }
//    }
//}
//
//struct View2: View {
//    @ObservedObject var coordinator: Coordinator
//
//    var body: some View {
//        Text("View 2")
//            .onTapGesture {
//                coordinator.navigateToView1()
//            }
//    }
//}
//
//class Coordinator: ObservableObject {
//    @Published var currentView: AnyView?
//
//    func navigateToView1() {
//        currentView = AnyView(View1(coordinator: self))
//    }
//
//    func navigateToView2() {
//        currentView = AnyView(View2(coordinator: self))
//    }
//}
