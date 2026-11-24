//
//  AddApplicationView.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 18/11/26.
//

import SwiftUI
import SwiftData

struct AddApplicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var companyName = ""
    @State private var jobTitle = ""
    @State private var location = ""
    @State private var jobPostingURL = ""
    @State private var applicationDate = Date.now
    @State private var status: Status = .applied
    @State private var salary = ""
    @State private var interviewDate =  Date.now
    private var saveButtonDisable: Bool {
        companyName.trimmingCharacters(in: .whitespaces).isEmpty || jobTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
    @State private var remindersEnable = false
    
    
    var body: some View {
        NavigationStack {
            Form{
                VStack(alignment:.leading ,spacing: 20) {
                    textField("Company Name", text: $companyName)
                    textField("Job Title", text:$jobTitle)
                    textField("Location", text: $location)
                    textField("Job Posting URL", text: $jobPostingURL)
                    DatePicker("Application Date", selection: $applicationDate,displayedComponents: .date)
                    Picker("Status", selection: $status){
                        Text("Applied").tag(Status.applied)
                        Text("Accepted").tag(Status.accepted)
                        Text("Rejected").tag(Status.rejected)
                        Text("Interview").tag(Status.interview)
                    }
                        if status == .interview{
                            DatePicker("Interview Date", selection: $interviewDate)
                            Toggle("Interview Reminder", isOn: $remindersEnable)
                                .onChange(of: remindersEnable) { _, isEnabled in
                                if isEnabled {
                                    Task {
                                        do {
                                            let granted = try await NotificationManager()
                                                .requestPermission()

                                            if !granted {
                                                remindersEnable = false
                                            }
                                        } catch {
                                            remindersEnable = false
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                        }
                    textField("Salary", text: $salary)
                            .keyboardType(.numberPad)
                    
                    
                    
                }
                
                .navigationTitle("Add Application")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Save"){
                            Task {
                                await save()
                            }
                        }
                        .disabled(saveButtonDisable)
                    }
                }
                
            }
            
        }
    }
        
        
    func save() async{
            let newInterviewDate: Date?
            let newSalary: String?
            var reminder: Bool = false
            if status == .interview && remindersEnable{
                reminder = true
            }
            if  salary != ""{
                newSalary = salary
            }
            else{
                newSalary = nil
            }
            if status == .interview{
                newInterviewDate = interviewDate
                
            }
            else{
                newInterviewDate = nil
                
            }
            let application = Application(companyName: companyName, jobTitle: jobTitle, location: location, jobPostingURL: jobPostingURL, applicationDate: applicationDate, status: status, salary: newSalary, interviewDate: newInterviewDate,reminder:reminder)
            modelContext.insert(application)
            do{
                try modelContext.save()
                try await NotificationManager()
                    .scheduleReminder(for: application)
                dismiss()
            }catch{
                print(error.localizedDescription)
            }
            
        }
        
        func textField(_ title:String, text: Binding<String>)-> some View{
            Section(title){
                TextField(title, text: text)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                
                    .padding(.horizontal)
                    .padding(.vertical,8)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray,lineWidth: 3)
                    }
                
            }
        }
    }




#Preview {
    AddApplicationView()
        .preferredColorScheme(.dark)
}
