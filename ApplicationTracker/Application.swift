//
//  Application.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 18/11/26.
//

import SwiftUI
import SwiftData

@Model
class Application{
    var reminderID: String = UUID().uuidString
    var companyName: String
    var jobTitle: String
    var location: String
    var jobPostingURL: String
    var applicationDate: Date
    var status: Status
    var salary: String?
    var interviewDate: Date?
    var reminder : Bool = false
    
    init(companyName: String, jobTitle: String, location: String, jobPostingURL: String, applicationDate: Date, status: Status, salary: String? = nil, interviewDate: Date? = nil,reminder : Bool) {
        self.companyName = companyName
        self.jobTitle = jobTitle
        self.location = location
        self.jobPostingURL = jobPostingURL
        self.applicationDate = applicationDate
        self.status = status
        self.salary = salary
        self.interviewDate = interviewDate
        self.reminder = reminder
    }
}

enum Status: String, Codable{
    case applied = "Applied"
    case accepted = "Accepted"
    case rejected = "Rejected"
    case interview = "Interview"
}

extension Application{
    
    static let example = Application(companyName: "Example Technologies",
                                            jobTitle: "Junior iOS Developer",
                                            location: "Bengaluru",
                                            jobPostingURL: "https://example.com/jobs/ios",
                                            applicationDate: .now,
                                            status: .interview,
                                            salary: "600000",
                                            interviewDate: .now.addingTimeInterval(86_400),
                                            reminder: false)
}
