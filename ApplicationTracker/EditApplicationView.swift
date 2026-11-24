//
//  EditApplicationView.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 19/11/26.
//

import SwiftUI

struct EditApplicationView: View {
    @Environment(\.dismiss) var dismiss
    let application : Application
    var onSave: (Application) -> Void
    @State private var companyName: String
    @State private var jobTitle : String
    @State private var location : String
    @State private var jobPostingURL : String
    @State private var applicationDate : Date
    @State private var status: Status
    @State private var salary :  String
    @State private var interviewDate : Date
    @State private var remindersEnable = false
    
    
    init(application: Application,onSave: @escaping (Application) -> Void) {
        self.application = application
        self.onSave = onSave
        
        _companyName = State(initialValue: application.companyName)
        _jobTitle = State(initialValue: application.jobTitle)
        _location = State(initialValue: application.location)
        _jobPostingURL = State(initialValue: application.jobPostingURL)
        _status = State(initialValue: application.status)
        _applicationDate = State(initialValue: application.applicationDate)
        _salary = State(initialValue: application.salary ?? "")
        _interviewDate = State(initialValue:application.interviewDate ?? Date.now)
        _remindersEnable = State(initialValue: application.reminder)
        
    }
    private var saveButtonDisable: Bool {
        companyName.trimmingCharacters(in: .whitespaces).isEmpty || jobTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }
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
                
                .navigationTitle("Edit Application")
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Save"){
                            save()
                            dismiss()
                            
                        }
                        .disabled(saveButtonDisable)
                    }
                    
                    ToolbarItem(placement: .topBarLeading){
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
                
            }
            
        }
        
    }
    func save(){
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
        
        let editedApplication = Application(companyName: companyName, jobTitle: jobTitle, location: location, jobPostingURL: jobPostingURL, applicationDate: applicationDate, status: status, salary: newSalary, interviewDate: newInterviewDate,reminder: reminder)
        
        onSave(editedApplication)
        
        
        
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
    EditApplicationView(application: .example){_ in}
}
