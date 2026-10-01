# VivaHeal 🏥

**A role-based healthcare appointment and patient management system built with Flutter and Firebase.**

VivaHeal is a healthcare management application designed to streamline interactions between **patients, doctors, and administrators** through a unified digital platform. The system provides appointment management, patient records, medical reports, role-based access, and real-time data synchronization using Firebase.

---

## ✨ Features

### 👨‍⚕️ Doctor

* View and manage assigned appointments
* Access patient information and medical history
* View uploaded medical reports
* Manage appointment-related information

### 🧑‍💻 Patient

* Secure account registration and authentication
* Browse and interact with doctor information
* Book and manage appointments
* View appointment details
* Upload and access medical reports
* Manage personal healthcare information

### 🛡️ Admin

* Manage doctors and patients
* Monitor appointments and system data
* Manage user roles and access
* Maintain centralized healthcare records

---

## 🏗️ System Architecture

VivaHeal consists of two Flutter applications:

```text
VivaHeal
│
├── 📱 Patient / Doctor Mobile Application
│   ├── Authentication
│   ├── Appointments
│   ├── Patient Records
│   ├── Medical Reports
│   └── Role-based Access
│
└── 💻 Admin / Doctor Web Application
    ├── Dashboard
    ├── User Management
    ├── Appointment Management
    └── Healthcare Data Management
```

---

## 🛠️ Tech Stack

### Frontend

* **Flutter**
* **Dart**
* Responsive UI

### Backend & Cloud

* **Firebase Authentication**
* **Cloud Firestore**
* **Firebase Storage**

### Development

* Git & GitHub
* Android Studio
* VS Code

---

## 🔐 Authentication & Authorization

VivaHeal uses **Firebase Authentication** for secure user authentication.

The application implements role-based access for:

```text
Patient
   ↓
Patient-specific healthcare data

Doctor
   ↓
Assigned patient & appointment information

Admin
   ↓
System-level management
```

Each patient's records are associated with their authenticated user identity, helping ensure that healthcare information is accessed according to the user's role and permissions.

---

## 📂 Medical Reports

Medical reports are uploaded and managed through Firebase Storage.

Example storage structure:

```text
patient_reports/
└── <patient-id>/
    ├── report_1
    ├── report_2
    └── report_3
```

Report metadata and related information are maintained alongside the application's Firestore data.

---

## 🗄️ Data Management

Cloud Firestore is used as the primary database for storing application data such as:

* User profiles
* Doctor information
* Patient information
* Appointments
* Medical records
* Report metadata

The application synchronizes data with Firebase to provide a consistent experience across the supported applications.

---

## 📱 Applications

### Patient / Doctor Mobile App

The Flutter mobile application provides the primary interface for patients and doctors, including authentication, appointments, patient information, and medical reports.

### Admin / Doctor Web App

A separate Flutter Web application provides administrative and doctor-oriented functionality for managing healthcare-related data and workflows.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Git
* A Firebase project

Check your Flutter installation:

```bash
flutter doctor
```

---

### 1. Clone the Repository

```bash
git clone https://github.com/AKILAN-VS/VivaHeal-Mobile.git
cd VivaHeal-Mobile
```

---

### 2. Install Dependencies

```bash
flutter pub get
```

---

### 3. Configure Firebase

Create a Firebase project and configure the required Firebase services:

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

Add the appropriate Firebase configuration files for your target platform.

> **Note:** Firebase configuration files and credentials should not be committed if they contain sensitive project information.

---

### 4. Run the Application

```bash
flutter run
```

For Flutter Web:

```bash
flutter run -d chrome
```

---

## 📸 Screenshots

Add application screenshots here to showcase the main workflows.

### Login & Authentication

> Add screenshot

### Patient Dashboard

> Add screenshot

### Doctor Dashboard

> Add screenshot

### Appointment Management

> Add screenshot

### Medical Reports

> Add screenshot

### Admin Dashboard

> Add screenshot

---

## 🔄 Core Workflow

```text
User Registration
       ↓
Firebase Authentication
       ↓
Role Identification
       ↓
┌──────────┬──────────┬──────────┐
│ Patient  │  Doctor  │  Admin   │
└────┬─────┴────┬─────┴────┬─────┘
     ↓           ↓           ↓
Appointments  Patients   Management
     ↓           ↓           ↓
Medical Data ← Firestore → System Data
     ↓
Firebase Storage
     ↓
Medical Reports
```

---

## 🎯 Project Objectives

* Digitize healthcare appointment workflows
* Provide role-specific interfaces for patients, doctors, and administrators
* Centralize patient and appointment information
* Enable secure access to medical reports
* Provide real-time synchronization using Firebase
* Build a scalable cross-platform healthcare application

---

## 🔮 Future Improvements

Potential future enhancements include:

* Push notifications for appointment updates
* Online doctor-patient consultations
* Appointment reminders
* Advanced doctor availability management
* Healthcare analytics and reporting
* Improved medical-record organization
* Additional security and access-control mechanisms

---

## 👨‍💻 Developer

**Akilan V S**

B.Tech Computer Science and Engineering
Vellore Institute of Technology, Chennai

* GitHub: https://github.com/AKILAN-VS
* Portfolio: https://akilan-vs-portfolio.vercel.app/

---

## 📄 License

This project is developed for academic and project purposes.
