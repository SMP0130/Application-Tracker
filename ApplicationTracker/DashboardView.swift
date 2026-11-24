//
//  Dashboard.swift
//  ApplicationTracker
//
//  Created by Patel Smit on 18/11/26.
//

import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Query var applications : [Application]
    var interviewCount: Int {
        var count = 0
        for application in applications {
            if application.status == .interview{
                count += 1
            }
        }
        return count
    }
    var appliedCount: Int {
        var count = 0
        for application in applications {
            if application.status == .applied{
                count += 1
            }
        }
        return count
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                HStack{
                    VStack{
                        Text("Total Application")
                            .font(.headline.bold())
                        Text("\(applications.count)")
                            .font(.subheadline.bold())
                    }
                    .padding()
                    .frame(height:55)
                    .frame(maxWidth: 185)
                    .background(.white.opacity(0.4))
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white,lineWidth: 2)
                    }
                    .shadow(color: .white.opacity(0.2), radius: 0.2,y: 0.2)
                    Spacer()
                    VStack{
                        Text("Interview")
                            .font(.headline.bold())
                        Text("\(interviewCount)")
                            .font(.subheadline.bold())
                    }
                    .padding()
                    .frame(height:55)
                    .frame(maxWidth: 185)
                    .background(.white.opacity(0.4))
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white,lineWidth: 2)
                    }
                    .shadow(color: .white.opacity(0.2), radius: 0.2,y: 0.2)
                }
                .padding(.horizontal)
                Chart {
                    BarMark(
                        x: .value("Status", "Interview"),
                        y: .value("Applications", interviewCount)
                    )
                    BarMark(
                        x: .value("Status", "Applied"),
                        y: .value("Applications", appliedCount)
                    )
                }
                .frame(height: 220)
                .padding()
            }
            Spacer()
                .navigationTitle("Dashboard")
        }
        
        
    }
}

#Preview {
    DashboardView()
        .preferredColorScheme(.dark)
}
