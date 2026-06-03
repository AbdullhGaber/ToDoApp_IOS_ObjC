# ToDoApp - iOS Objective-C

A clean, responsive, and robust ToDo/Task Management application built natively for iOS using **Objective-C**. This project demonstrates core iOS development concepts, including structured architecture, local data persistence, interactive UI layouts, and asynchronous task execution.

## 🚀 Features

- **Task Lifecycle Management:** Create, read, update, and delete (CRUD) tasks seamlessly.
- **Categorization & Priority:** Organize tasks by categories (e.g., Work, Personal, Shopping) and prioritize them (Low, Medium, High).
- **Status Tracking:** Separate views for "Todo", "In Progress", and "Done" tasks to stay organized.
- **Search & Filter:** Easily find specific tasks using a real-time search bar and filter criteria.
- **Local Persistence:** Data is securely saved locally on the device, ensuring your tasks are preserved across app restarts.
- **Interactive UI:** Smooth transitions, swipable table view rows for quick actions (edit/delete), and a clean, user-friendly layout.

## 🛠️ Tech Stack & Architecture

- **Language:** Objective-C
- **Framework:** UIKit
- **Architecture:** Model-View-Controller (MVC)
- **Persistence:** `NSUserDefaults`
- **UI Layout:** Auto Layout & Storyboards / XIBs

## 📸 Screenshots

### 🔹 Core Application Flow
| Splash Screen | Empty State | Adding a Task | Adding Due Date |
| :---: | :---: | :---: | :---: |
|<img width="180" src="https://github.com/user-attachments/assets/e5b9ff2e-aff7-4127-b33d-725117dc7c69" />|<img width="180" src="https://github.com/user-attachments/assets/08c738ef-3f1e-4413-a227-8b7d41c28104" />|<img width="180" src="https://github.com/user-attachments/assets/7163e4b0-0a7d-49c5-8949-2477bcf5a6f9" />|<img width="180" src="https://github.com/user-attachments/assets/68ea1ec5-a100-4a4b-9d52-0a6f0947be22" />|  

### 🔹 Task Details, Attachments & Reminders
| Show Task Details | Delete Attachment in Edit | Notification Display |
| :---: | :---: | :---: |
|<img width="180" src="https://github.com/user-attachments/assets/7f17f5ba-8585-4613-bbde-a549f4f91b6f" />|<img width="180" src="https://github.com/user-attachments/assets/8ef7d723-22e6-46cd-9f02-f6b55fad604e" />|<img width="180" src="https://github.com/user-attachments/assets/b3c110f0-1770-410e-b25a-607482fe2d0f" />|

### 🔹 Task Views & Filtering
| Display All Tasks | Display Priority Tasks | Checked / Done Tasks |
| :---: | :---: | :---: |
|<img width="180" src="https://github.com/user-attachments/assets/ac91e72d-ee9e-477c-bf30-773fd6246e0b" />|<img width="180" src="https://github.com/user-attachments/assets/91918832-dcca-425f-8747-0bcdb0b48603" />|<img width="180" src="https://github.com/user-attachments/assets/0fe54dd4-5fe7-448c-9524-db66c86a3b05" />|

## ⚙️ Installation & Setup

To get a local copy up and running, follow these simple steps:

### Prerequisites
- a Mac running **macOS**
- **Xcode 15+** installed
- **iOS 15.0+** Target SDK

### Step-by-Step Guide

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/AbdullhGaber/ToDoApp_IOS_ObjC.git](https://github.com/AbdullhGaber/ToDoApp_IOS_ObjC.git)
Open the project in Xcode:

Navigate to the cloned folder.

Open the .xcodeproj file.

Bash
cd ToDoApp_IOS_ObjC
open ToDoApp_IOS_ObjC.xcodeproj
Run the application:

Select your preferred iOS Simulator (e.g., iPhone 15) or a physical test device from the active scheme dropdown.

Press Cmd + R or click the Play button in Xcode to build and run the app.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request
