import Foundation
import SwiftData

struct DemoData {
    // DOCTORS
    static let doctors = [
        User(
            firstName: "Abdullah",
            lastName: "Al-Ghamdi",
            email: "abdullah.ghamdi@hospital.com",
            phoneNumber: "0501234567",
            department: "Cardiology",
            specialty: "Interventional Cardiology",
            role: .doctor,
            status: .active,
            employeeId: "D1001"
        ),
        User(
            firstName: "Fatima",
            lastName: "Al-Saad",
            email: "fatima.saad@hospital.com",
            phoneNumber: "0502345678",
            department: "Pediatrics",
            specialty: "Pediatric Oncology",
            role: .doctor,
            status: .active,
            employeeId: "D1002"
        ),
        User(
            firstName: "Mohammed",
            lastName: "Al-Shehri",
            email: "mohammed.shehri@hospital.com",
            phoneNumber: "0503456789",
            department: "Emergency Medicine",
            specialty: "Emergency Medicine",
            role: .doctor,
            status: .onCall,
            employeeId: "D1003"
        ),
        User(
            firstName: "Aisha",
            lastName: "Al-Otaibi",
            email: "aisha.otaibi@hospital.com",
            phoneNumber: "0504567890",
            department: "Internal Medicine",
            specialty: "Pulmonology",
            role: .doctor,
            status: .active,
            employeeId: "D1004"
        )
    ]
    
    // NURSES
    static let nurses = [
        User(
            firstName: "Noura",
            lastName: "Al-Qahtani",
            email: "noura.qahtani@hospital.com",
            phoneNumber: "0505678901",
            department: "ICU",
            specialty: "Critical Care",
            role: .nurse,
            status: .active,
            employeeId: "N2001"
        ),
        User(
            firstName: "Ahmed",
            lastName: "Al-Dossari",
            email: "ahmed.dossari@hospital.com",
            phoneNumber: "0506789012",
            department: "Emergency",
            specialty: "Emergency Care",
            role: .nurse,
            status: .active,
            employeeId: "N2002"
        ),
        User(
            firstName: "Hessa",
            lastName: "Al-Shamri",
            email: "hessa.shamri@hospital.com",
            phoneNumber: "0507890123",
            department: "Cardiology",
            specialty: "Cardiac Care",
            role: .nurse,
            status: .active,
            employeeId: "N2003"
        ),
        User(
            firstName: "Bandar",
            lastName: "Al-Subaie",
            email: "bandar.subaie@hospital.com",
            phoneNumber: "0508901234",
            department: "Pediatrics",
            specialty: "Pediatric Care",
            role: .nurse,
            status: .onCall,
            employeeId: "N2004"
        )
    ]
    
    // SPECIALISTS
    static let specialists = [
        User(
            firstName: "Reem",
            lastName: "Al-Malki",
            email: "reem.malki@hospital.com",
            phoneNumber: "0509012345",
            department: "Radiology",
            specialty: "Diagnostic Imaging",
            role: .specialist,
            status: .active,
            employeeId: "S3001"
        ),
        User(
            firstName: "Khalid",
            lastName: "Al-Harbi",
            email: "khalid.harbi@hospital.com",
            phoneNumber: "0510123456",
            department: "Laboratory",
            specialty: "Clinical Pathology",
            role: .specialist,
            status: .active,
            employeeId: "S3002"
        )
    ]
    
    // STAFF
    static let staff = [
        User(
            firstName: "Layla",
            lastName: "Al-Zahrani",
            email: "layla.zahrani@hospital.com",
            phoneNumber: "0511234567",
            department: "Administration",
            specialty: "Patient Services",
            role: .staff,
            status: .active,
            employeeId: "A4001"
        ),
        User(
            firstName: "Omar",
            lastName: "Al-Mutairi",
            email: "omar.mutairi@hospital.com",
            phoneNumber: "0512345678",
            department: "IT",
            specialty: "Technical Support",
            role: .staff,
            status: .active,
            employeeId: "A4002"
        )
    ]
    
    // Combine all users
    static let users = doctors + nurses + specialists + staff
    
    // PATIENTS BY UNIT
    
        // ICU Patients
    static let icuPatients = [
        Patient(
            firstName: "Ahmed",
            lastName: "Al-Rashid",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -65, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123456",
            wardInfo: Patient.WardInfo(
                floorNumber: 1,
                wardNumber: "ICU",
                bedNumber: "ICU-1"
            ),
            roomNumber: "ICU-1",
            assignedTeam: [],
            status: .critical,
            chiefComplaint: "Acute respiratory failure"
        ),
        // Add more ICU patients...
    ]
        
        // Ward 3A Patients
    static let ward3APatients = [
        Patient(
            firstName: "Fatima",
            lastName: "Al-Ghamdi",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -52, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123459",
            wardInfo: Patient.WardInfo(
                floorNumber: 3,
                wardNumber: "3A",
                bedNumber: "302-A"
            ),
            roomNumber: "302-A",
            assignedTeam: [],
            status: .stable,
            chiefComplaint: "Fever and productive cough"
        ),
        Patient(
            firstName: "Khalid",
            lastName: "Al-Harbi",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -45, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123460",
            wardInfo: Patient.WardInfo(
                floorNumber: 3,
                wardNumber: "3A",
                bedNumber: "303-A"
            ),
            roomNumber: "303-A",
            assignedTeam: [],
            status: .stable
        )
    ]
        
        // Ward 3B Patients
    static let ward3BPatients = [
        Patient(
            firstName: "Sara",
            lastName: "Al-Qahtani",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -35, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123461",
            wardInfo: Patient.WardInfo(
                floorNumber: 3,
                wardNumber: "3B",
                bedNumber: "310-B"
            ),
            roomNumber: "310-B",
            assignedTeam: [],
            status: .stable
        )
    ]
        
        // Ward 4A Patients
    static let ward4APatients = [
        Patient(
            firstName: "Mohammed",
            lastName: "Al-Dossari",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -58, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123462",
            wardInfo: Patient.WardInfo(
                floorNumber: 4,
                wardNumber: "4A",
                bedNumber: "401-A"
            ),
            roomNumber: "401-A",
            assignedTeam: [],
            status: .serious
        )
    ]
        
        // Ward 4B Patients
    static let ward4BPatients = [
        Patient(
            firstName: "Noura",
            lastName: "Al-Shehri",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -42, to: Date()) ?? Date(),
            medicalRecordNumber: "MRN-123463",
            wardInfo: Patient.WardInfo(
                floorNumber: 4,
                wardNumber: "4B",
                bedNumber: "410-B"
            ),
            roomNumber: "410-B",
            assignedTeam: [],
            status: .stable
        )
    ]
    
    // Combine all patients
    static let patients = icuPatients + ward3APatients + ward3BPatients + ward4APatients + ward4BPatients
    
    // Sample medications
    static let medications = [
        Medication(
            name: "Paracetamol",
            dosage: "500mg",
            frequency: "Q6H",
            startDate: Date(),
            endDate: Date().addingTimeInterval(7*24*60*60)
        ),
        Medication(
            name: "Amoxicillin",
            dosage: "500mg",
            frequency: "TID",
            startDate: Date(),
            endDate: Date().addingTimeInterval(10*24*60*60)
        ),
        Medication(
            name: "Atorvastatin",
            dosage: "20mg",
            frequency: "Daily",
            startDate: Date(),
            endDate: Date().addingTimeInterval(30*24*60*60)
        )
    ]
} 
