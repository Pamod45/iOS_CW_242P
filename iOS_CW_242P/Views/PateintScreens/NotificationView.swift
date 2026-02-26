//
//  NotificationView.swift
//  iOS_CW_242P
//
//  Created by Liviru Navaratna on 2026-02-26.
//

import SwiftUI

struct NotificationView : View {
    @State private var notifications = MockData.sampleNotifications
    @State private var selectedFilter: NotificationFilter = .all
    
    private var filteredNotifications: [AppNotification] {
        notifications.filter { $0.matchesFilter(selectedFilter) }
    }
    
    private var groupedNotifications: [(String, [AppNotification])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredNotifications) { notification -> String in
            if calendar.isDateInToday(notification.timestamp) {
                return "Today"
            } else if calendar.isDateInYesterday(notification.timestamp) {
                return "Yesterday"
            } else {
                return "Earlier"
            }
        }
        
        let order = ["Today", "Yesterday", "Earlier"]
        return order.compactMap { key in
            guard let items = grouped[key] else { return nil }
            return (key, items.sorted { $0.timestamp > $1.timestamp })
        }
    }
    
    var body : some View {
        NavigationView {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Filter Chips
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(NotificationFilter.allCases, id: \.self) { filter in
                                        FilterChip(
                                            title: filter.rawValue,
                                            isSelected: selectedFilter == filter,
                                            count: countForFilter(filter)
                                        ) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedFilter = filter
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Notification Groups
                            if filteredNotifications.isEmpty {
                                EmptyNotificationsView(filter: selectedFilter)
                                    .padding(.top, 40)
                            } else {
                                LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                                    ForEach(groupedNotifications, id: \.0) { section, items in
                                        Section {
                                            VStack(spacing: 12) {
                                                ForEach(items) { notification in
                                                    NotificationCard(notification: notification)
                                                }
                                            }
                                            .padding(.horizontal)
                                        } header: {
                                            HStack {
                                                Text(section)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                Spacer()
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color(.systemGroupedBackground))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 40)
                    }
                    .background(Color(.systemGroupedBackground))
                    .navigationTitle("Notifications")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
    
    //Functions
    private func countForFilter(_ filter: NotificationFilter) -> Int {
        notifications.filter { $0.matchesFilter(filter) }.count
    }
}
