# Application Tracker

Application Tracker is a native iOS application for recording and organizing job applications. It uses SwiftData for local persistence, Swift Charts for dashboard visualizations, and UserNotifications for interview reminders.

## Features

- Add, view, edit, and delete job applications
- Store company, role, status, application date, notes, and interview details
- Validate required form fields before saving
- Search by company or role
- Filter applications by status
- Sort by company name or application date
- View computed application counts and recruitment-stage charts
- Schedule local interview reminders
- Display clear empty and no-result states

## Technologies

- Swift and SwiftUI
- SwiftData with `@Model` and `@Query`
- Swift Charts
- UserNotifications
- Draft-based add and edit forms
- Closures for save actions and parent-child data flow

## Setup

1. Clone the repository.
2. Open `ApplicationTracker.xcodeproj` in Xcode.
3. Select an iOS Simulator or connected device.
4. Build and run the application.
5. Allow notification permission if you want to test interview reminders.

Application data is stored locally using SwiftData.

## Author

Smit Patel
