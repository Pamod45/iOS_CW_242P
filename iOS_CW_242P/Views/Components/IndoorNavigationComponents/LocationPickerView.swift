//
//  LocationPickerView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-03-11.
//

import SwiftUI

struct LocationPickerView: View {
    @Binding var isPresented: Bool
    let title: String
    let selectedLocation: MapLocation?
    let onLocationSelected: (MapLocation) -> Void
    let allowQRScan: Bool
    
    @State private var searchText: String = ""
    @State private var showQRScanner: Bool = false
    @State private var selectedFloor: Int? = nil
    @State private var selectedType: LocationTypes? = nil
    
    let floors = [1, 2]
    
    struct TypeFilter: Identifiable, Equatable {
        let id = UUID()
        let label: String
        let type: LocationTypes?
    }
    
    let typeFilters: [TypeFilter] = [
        TypeFilter(label: "All", type: nil),
        TypeFilter(label: "Doctor Rooms", type: .doctorRoom),
        TypeFilter(label: "Laboratory", type: .laboratory),
        TypeFilter(label: "Pharmacy", type: .pharmacy),
        TypeFilter(label: "Restrooms", type: .restroom),
        TypeFilter(label: "Elevator / Stairs", type: .elevator),
    ]
    
    var filteredLocations: [MapLocation] {
        var clinicLocations = MockData.sampleLocations
        
        if let floor = selectedFloor {
            clinicLocations = clinicLocations.filter({
                $0.floor == floor
            })
        }
        
        if let type = selectedType {
            if type == .elevator {
                clinicLocations = clinicLocations.filter { $0.type == .elevator || $0.type == .stairs }
            } else {
                clinicLocations = clinicLocations.filter { $0.type == type }
            }
        }
        
        if !searchText.isEmpty {
            clinicLocations = clinicLocations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return clinicLocations
    }
    
    var groupedLocations: [LocationTypes : [MapLocation]] {
        Dictionary(grouping: filteredLocations){
            $0.type
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                //Add search bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search locations...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
                
                //Add the QR Button
                if (allowQRScan == true) {
                    Button(action: { showQRScanner = true }) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.white)
                                .font(.title3)
                            Text("Scan QR Code")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                
                //Filters
                HStack(spacing: 12) {
                    // Floor dropdown
                    Menu {
                        Button(action: { selectedFloor = nil }) {
                            Label("All Floors", systemImage: selectedFloor == nil ? "checkmark" : "building.2")
                        }
                        ForEach(floors, id: \.self) { floor in
                            Button(action: { selectedFloor = floor }) {
                                Label("Floor \(floor)", systemImage: selectedFloor == floor ? "checkmark" : "building.2")
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "building.2")
                                .font(.caption)
                            Text(selectedFloor == nil ? "All Floors" : "Floor \(selectedFloor!)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Location type dropdown
                    Menu {
                        ForEach(typeFilters) { filter in
                            Button(action: { selectedType = filter.type }) {
                                Label(filter.label, systemImage: selectedType == filter.type ? "checkmark" : (filter.type?.icon ?? "square.grid.2x2"))
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: selectedType?.icon ?? "square.grid.2x2")
                                .font(.caption)
                            Text(typeFilters.first(where: { $0.type == selectedType })?.label ?? "All")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                //Locations
                ScrollView{
                    LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]){
                        ForEach(Array(groupedLocations.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { type in
                            Section{
                                VStack(spacing: 12){
                                    ForEach(groupedLocations[type] ?? []){ location in
                                        LocationRow(
                                            location:location,
                                            isSelected: location.id == selectedLocation?.id
                                        ) {
                                            onLocationSelected(location)
                                            isPresented = false
                                        }
                                    }
                                }
                            }header: {
                                HStack {
                                    Image(systemName: type.icon)
                                        .foregroundColor(.blue)
                                    Text(type.rawValue)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color(.systemGroupedBackground))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .sheet(isPresented: $showQRScanner) {
                QRScannerView(isPresented: $showQRScanner) { location in
                    onLocationSelected(location)
                    isPresented = false
                }
            }
        }
    }
}


//Location Row

struct LocationRow: View {
    let location: MapLocation
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect){
            HStack(spacing: 16){
                Image(systemName: location.type.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(spacing: 4){
                    Text(location.name)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 4){
                        Image(systemName: "building.2")
                            .font(.caption2)
                        Text("Floor \(location.floor)")
                            .font(.caption2)
                    }
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}
#Preview{
   LocationPickerView(
        isPresented: .constant(true),
        title: "Pick a location",
        selectedLocation: nil,
        onLocationSelected: { _ in },
        allowQRScan: true
    )
}
