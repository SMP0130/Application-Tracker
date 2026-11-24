//
//  ApplicationListView.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 18/11/26.
//

import SwiftUI
import SwiftData

struct ApplicationListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.applicationDate, order: .reverse) var applications :  [Application]
    @State private var isShowingSheet = false
    @State private var search = ""
    var filteredApplication : [Application]{
        if search.isEmpty{
            return applications
        }else{
            return applications.filter{
                $0.jobTitle.localizedStandardContains(search)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List{
                if !filteredApplication.isEmpty {
                    ForEach(filteredApplication,id: \.self){ application in
                        NavigationLink{
                            ApplicationDetailView(application: application)
                        }label: {
                            HStack{
                                VStack{
                                    Text(application.jobTitle)
                                        .font(.title2)
                                    Text(application.companyName)
                                        .font(.caption)
                                }
                                Spacer()
                                Text(application.status.rawValue)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                else{
                    if !search.isEmpty {
                            ContentUnavailableView {
                                Text("Cannot find matching results to \(search)")
                            }
                        }
                    else{
                        ContentUnavailableView{
                            Text("No Applications Yet")
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add",systemImage: "plus"){
                        isShowingSheet = true
                    }
                }
            }
            .navigationTitle("Applications")
            .searchable(text: $search ,placement: .navigationBarDrawer(displayMode: .always),prompt:"Search")
        }
        .sheet(isPresented: $isShowingSheet){
            AddApplicationView()
        }

        .onAppear{
            print(applications.count)
        }
    }
        
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let application = filteredApplication[index]
            let id = application.reminderID
            NotificationManager().cancelReminder(id: id)
            modelContext.delete(application)
            
        }
    }
}

#Preview {
    ApplicationListView()
        .preferredColorScheme(.dark)
}
