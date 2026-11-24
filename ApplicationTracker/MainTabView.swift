//
//  MainTabView.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 18/11/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            Tab("Dashboard",systemImage: "square.grid.2x2"){
                DashboardView()
            }
            Tab("Application",systemImage: "list.bullet.rectangle"){
                ApplicationListView()
            }
            Tab("System",systemImage: "gearshape"){
                
            }
        }
    }
}

#Preview {
    MainTabView()
        .preferredColorScheme(.dark)
}
