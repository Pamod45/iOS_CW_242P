//
//  MockDataManager.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-13.
//

import Combine
class DataManager: ObservableObject {
    @Published var sampleJourneys: [Journey] = MockData.sampleJourneys
    @Published var sampleBookings: [Appointment] = MockData.sampleBookings
    @Published var sessions: [Session] = MockData.sessions
    
    static let shared = DataManager()
}
