//
//  JourneyView.swift
//  iOS_CW_242P
//
//  Created by Pubudu Perera on 2026-03-09.
//

import SwiftUI
struct JourneyView: View {
    var body: some View {
        ScrollView{
            VStack(spacing:32){
                ZStack{
                    Circle().stroke(Color(.systemGray5), lineWidth: 16)
                    
                    Circle().trim(from: 0, to: 0.4).stroke(Color.blue, style: StrokeStyle(lineWidth: 16, lineCap: .round)).rotationEffect(.degrees(-90))
                    
                    VStack{
                        Text("40%").font(.largeTitle).fontWeight(.bold)
                        Text("Completed").foregroundColor(.secondary)
                    }
                }.padding(.horizontal,104)
                
                VStack(alignment:.center){
                    Text("Please follow the steps to complete \n your journey").multilineTextAlignment(.center).foregroundColor(Color(.systemGray))
                        .font(.subheadline)
                        .fontWeight(.regular)
                }
                
                VStack(alignment:.leading, spacing: 0){
                    VStack(spacing: 16){
                        HStack(alignment: .top, spacing: 16){
                            Image(systemName: "flask")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .padding(12)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            VStack (alignment: .leading){
                                Text("Current Step").font(.footnote).foregroundColor(.secondary)
                                Text("Laboratory").font(.title3).fontWeight(.bold)
                                    Text("Lab Room").font(.footnote).foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        Divider()
                        VStack(){
                            HStack(spacing: 24){
                                VStack(alignment: .center,spacing: 4){
                                    Text("Queue No #").font(.footnote).foregroundColor(.secondary)
                                    Text("5").foregroundColor(.blue).fontWeight(.bold)
                                }
                                VStack(alignment: .center, spacing: 4){
                                    Text("Wait Time").font(.footnote).foregroundColor(.secondary)
                                    Text("~ 15 min").foregroundColor(.orange).fontWeight(.bold)
                                }
                                Spacer()
                                    Image(systemName: "location.fill")
                                        .font(.title2)
                                        .padding()
                                        .background(Color.white.opacity(0.6))
                                        .clipShape(Circle())
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            }
                        }
                    }.padding()
                }.background(.gray.opacity(0.08)).cornerRadius(16)
                VStack(){
                    HStack(alignment: .top, spacing: 16){
                        Image(systemName: "checkmark")
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.all,10)
                            .background(.green.opacity(0.2))
                            .fontWeight(.bold)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 6){
                            HStack(spacing: 8){
                                Image(systemName: "person.badge.plus").foregroundColor(.green).font(.headline)
                                Text("Registration").font(.headline).foregroundColor(.secondary)
                            }
                            
                            Text("Complete your registration").font(.subheadline).foregroundColor(.secondary)
                            HStack(spacing: 6){
                                Image(systemName: "info.circle").font(.caption).foregroundColor(.blue)
                                Text("Reception").font(.footnote).foregroundColor(.blue)
                            }
                            
                            Text("Completed at 01:05").font(.footnote).foregroundColor(.green)
                            
                        }.frame(maxWidth:.infinity, alignment: .leading)
                        
                        Text("Confirmed").font(.caption).fontWeight(.semibold).foregroundColor(.green).padding(.all,8).background(.green.opacity(0.1)).cornerRadius(8)
                        
                    }.padding()
                    Divider().padding(.horizontal)
                    HStack(alignment: .top, spacing: 16){
                        Image(systemName: "checkmark")
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.all,10)
                            .background(.green.opacity(0.2))
                            .fontWeight(.bold)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 6){
                            HStack(spacing: 8){
                                Image(systemName: "person.badge.plus").foregroundColor(.green).font(.headline)
                                Text("Doctor Consulation").font(.headline).foregroundColor(.secondary)
                            }
                            
                            Text("Meet with your doctor").font(.subheadline).foregroundColor(.secondary)
                            
                            Text("Completed just now").font(.footnote).foregroundColor(.green)
                            
                        }.frame(maxWidth:.infinity, alignment: .leading)
                        
                        Text("Confirmed").font(.caption).fontWeight(.semibold).foregroundColor(.green).padding(.all,8).background(.green.opacity(0.1)).cornerRadius(8)
                        
                    }.padding()
                }.background().cornerRadius(16)
            }.padding(.vertical)
             .padding(.horizontal)
            
        }.background(Color(.systemGroupedBackground))
            .navigationTitle("My Journey")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    JourneyView()
}
