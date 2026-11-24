//
//  ApplicationDetailView.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 18/11/26.
//

import SwiftUI
import SwiftData

struct ApplicationDetailView: View {
    let application : Application
    @Environment(\.modelContext) private var modelContext
    @State private var isSheetOn = false
    @State private var reminderError: String?
    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    VStack(alignment: .leading) {
                        Text("Company Name")
                            .font(.title2.bold())
                        Text(application.companyName)
                    }
                    VStack(alignment: .leading) {
                        Text("Job Location")
                            .font(.title2.bold())
                        Text(application.location)
                    }
                    VStack(alignment: .leading){
                        Text("Job Posting")
                            .font(.title2.bold())
                        Text(application.jobPostingURL)
                        
                    }
                    HStack{
                        Text("Application Date")
                            .font(.title2.bold())
                        Spacer()
                        Text(dateFormatter(date: application.applicationDate))
                    }
                    HStack{
                        Text("Status")
                            .font(.title2.bold())
                        Spacer()
                        Text(application.status.rawValue)
                    }
                    HStack{
                        Text("Salary")
                            .font(.title2.bold())
                        Spacer()
                        Text(application.salary ?? "Not Provided" )
                    }
                    HStack{
                        Text("Interview Date")
                            .font(.title2.bold())
                        Spacer()
                        if let interViewDate = application.interviewDate{
                            Text(interviewFormatter(date: interViewDate))
                        }
                    }
                    
                    
                    
                    
                }
                Button{
                    isSheetOn = true
                }label:{
                    Text("Edit Application")
                        .font(.title2.bold())
                        .frame(maxWidth:.infinity)
                        .frame(height: 55)
                        .background(.white.opacity(0.2))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white,lineWidth: 2 )
                        }
                        .padding()
                }
            }
            .sheet(isPresented: $isSheetOn){
                EditApplicationView(application: application){ editedApplication in
                    application.companyName = editedApplication.companyName
                    application.jobTitle = editedApplication.jobTitle
                    application.location = editedApplication.location
                    application.jobPostingURL = editedApplication.jobPostingURL
                    application.applicationDate = editedApplication.applicationDate
                    application.status = editedApplication.status
                    application.salary = editedApplication.salary
                    application.interviewDate = editedApplication.interviewDate
                    application.reminder = editedApplication.reminder
                    // Keep the existing reminder ID so edits target the same notification.
                    do {
                        try modelContext.save()
                        let notifications = NotificationManager()
                        notifications.cancelReminder(id: application.reminderID)
                        Task {
                            do {
                                try await notifications.scheduleReminder(for: application)
                            } catch {
                                reminderError = "Your changes were saved, but the interview reminder could not be scheduled. \(error.localizedDescription)"
                            }
                        }
                    } catch {
                        reminderError = "Your changes could not be saved. \(error.localizedDescription)"
                    }
                }
            }
            .alert("Application Update", isPresented: Binding(
                get: { reminderError != nil },
                set: { if !$0 { reminderError = nil } }
            )) {
                Button("OK", role: .cancel) { reminderError = nil }
            } message: {
                Text(reminderError ?? "")
            }
            .navigationTitle(application.jobTitle)
        }
        
    }
    func interviewFormatter(date:Date) -> String{
        let dateFormater = DateFormatter()
        return date.formatted(date: .abbreviated, time: .shortened)
    }
    func dateFormatter(date: Date) -> String{
        let dateFormater = DateFormatter()
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
}

#Preview {
    ApplicationDetailView(application: .example)
        .preferredColorScheme(.dark)
}
