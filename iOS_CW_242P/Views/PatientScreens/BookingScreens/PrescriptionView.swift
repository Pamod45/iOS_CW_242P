//
//  Prescription.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-08.
//

import SwiftUI
import Foundation

struct PrescriptionView: View {
    let appointment: Appointment
    let appointmentMedications: [Medication]
    
    let importantNotes: [String] = ["Take medications at the same time each day","Don't skip doses","Complete the full course","Consult doctor in case of side effects"]
    
    init() {
        self.appointment = MockData.sampleBookings[0]
        self.appointmentMedications = [
            Medication("Paracetamol","500mg",4,5),
            Medication("Amoxicillin","250mg",3,3)
        ]
    }
    
    var body: some View {
            ScrollView{
                VStack(spacing: 16){
                    VStack(spacing: 8){
                        InformationRaw(label: "Prescribed By", value: "Dr. Nihal Ambawatta")
                        
                        Divider().padding(.vertical,4)
                        
                        InformationRaw(label: "Issued Date", value: Date().formatted(date: .long, time: .omitted))
                        
                        Divider().padding(.vertical,4)
                        
                        InformationRaw(label: "Number of medications", value: "\(appointmentMedications.count)")
                        
                    }.padding().background(.white).cornerRadius(16)
                    
                    VStack(alignment: .leading){
                        
                        HStack(){
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                            Text("Important Notes").font(.headline)
                            Spacer()
                        }.padding(.horizontal)
                         .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 4){
                            ForEach(importantNotes, id: \.self){note in
                                ImportantNoteRow(importantNote: note)
                            }
                        }.padding(.horizontal).padding(.bottom)
                    }
                    .background(.orange.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.vertical)
                    VStack(alignment:.leading, spacing: 16){
                        HStack{
                            Image(systemName: "pill.fill").foregroundColor(Color.gray)
                            Text("Medication List").font(.headline)
                        }
                        ForEach(appointmentMedications){ med in
                            MedicationCard(medication: med.name, dosage: med.dosage,
                                           dailyFrequency: med.dailyFrequency, durationInDays: med.durationInDays)
                        }
                    }.padding(.all, 16).background(.white).cornerRadius(16)
                    
 
                }.padding(.horizontal).padding(.top)
                
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Prescription Details")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

private struct ImportantNoteRow: View{
    let importantNote: String
    var body: some View {
        HStack(alignment: .center, spacing: 16 ){
            Circle().frame(width: 8, height: 8).foregroundColor(.gray)
            Text(importantNote).font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct Medication: Identifiable, Codable{
    let id: String
    let name: String
    let dosage: String
    let dailyFrequency: Int
    let durationInDays: Int
    
    init(_ name: String, _ dosage: String, _ dailyFrequency: Int, _ durationInDays: Int){
        self.id = UUID().uuidString
        self.name = name
        self.dosage = dosage
        self.dailyFrequency = dailyFrequency
        self.durationInDays = durationInDays
        
    }
}

private struct InformationRaw: View {
    let label: String
    let value: String
    var body: some View {
        HStack(){
            Text(label).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            Text(value).font(.subheadline).fontWeight(.semibold)
        }
    }
}

struct MedicationCard: View {
    let medication: String
    let dosage: String
    let dailyFrequency: Int
    let durationInDays: Int
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 16){
                VStack(alignment: .leading, spacing: 4){
                    Text(medication)
                        .font(.headline)
                    Text(dosage)
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .center, spacing: 4){
                    Text("Frequency")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(dailyFrequency) times a day")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                VStack(alignment: .center, spacing: 4){
                    Text("Duration")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(durationInDays) days")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            
            
            HStack(alignment: .top, spacing: 16){
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemGray5))
        .cornerRadius(16)
    }
}

#Preview {
    PrescriptionView()
}
