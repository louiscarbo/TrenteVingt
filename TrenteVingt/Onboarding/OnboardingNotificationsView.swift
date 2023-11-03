//
//  OnboardingNotificationsView.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 03/11/2023.
//

import SwiftUI

struct OnboardingNotificationsView: View {
    @Binding var selectedTab: Int
    
    @State private var receiveNotifications = false
    @State private var hours = 0
    @State private var minutes = 0
    
    @State private var showTimeSettings = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.red.gradient)
                    Image(systemName: "bell.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .rotationEffect(Angle(degrees: 23))
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            Text("Do you want to receive reminders?")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
            Text("**TrenteVingt** can send you a notification each day to remind you to log your latest transactions.")
                .font(.system(.headline, design: .serif, weight: .regular))
            
            Toggle(isOn: $receiveNotifications, label: {
                Text("Receive notifications")
            })
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.gray.opacity(0.2))
            }
            .onChange(of: receiveNotifications) {
                if receiveNotifications == true {
                    NotificationHandler.shared.requestAuthorization()
                }
                UserDefaults.standard.set(receiveNotifications, forKey: "notificationsAreOn")
                withAnimation {
                    showTimeSettings = receiveNotifications
                }
            }
            if showTimeSettings {
                VStack {
                    HStack {
                        Text("At which time?")
                        Spacer()
                    }
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: hours) {
                            updateHoursMinutesInMemory()
                            NotificationHandler.shared.scheduleDailyNotifications()
                        }
                        Text(":")
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<12) { i in
                                Text("\(i*5)").tag(i*5)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: minutes) {
                            updateHoursMinutesInMemory()
                            NotificationHandler.shared.scheduleDailyNotifications()
                        }
                    }
                    .frame(height: 120)
                    Text("Each day, TrenteVingt will remind you to log your transactions at \(hours):\(String(format: "%02d", minutes)).")
                        .lineLimit(3, reservesSpace: true)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            Spacer()
            HStack {
                Button {
                    withAnimation {
                        selectedTab -= 1
                    }
                } label: {
                    Text("Previous")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                
                Spacer()
                
                Button {
                    withAnimation {
                        selectedTab += 1
                    }
                } label: {
                    Text("Next")
                        .font(.system(.title3, design: .serif))
                        .foregroundStyle(.white)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
            }
        }
        .padding()
    }
    
    func updateHoursMinutesInMemory() -> Void {
        UserDefaults.standard.set(hours, forKey: "hoursNotification")
        UserDefaults.standard.set(minutes, forKey: "minutesNotification")
    }
}

#Preview {
    OnboardingNotificationsView(selectedTab: .constant(4))
}
