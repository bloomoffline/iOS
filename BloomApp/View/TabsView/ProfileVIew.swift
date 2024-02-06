//
//  ProfileView.swift
//  BloomApp
//
// 
//

import SwiftUI
import Bloom

struct ProfileView: View {
    @EnvironmentObject private var profile: Profile
    @EnvironmentObject private var settings: Settings
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    
                    HStack(alignment: .center, spacing: 8) {
                        ZStack(alignment: .bottomTrailing) {
                            Image("ic_profile_2_tmp")
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                                .foregroundColor(.primary)
                        }
                        
                        VStack {
                            TextField("Your name", text: $profile.presence.user.name)
                                .font(.title3)
                            TextField("Your bio", text: $profile.presence.info)
                        }
                    }
                    .background(Color.clear)
                } header: {
                    Text("Profile")
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                Section {
                    //                    EnumPicker(selection: $profile.presence.status, label: Text("test"))
                    //                        .pickerStyle(MenuPickerStyle())
                    List(ChatStatus.allCases, id: \.rawValue) { value in
                        Button(action: {
                            profile.presence.status = value
                        }, label: {
                            HStack {
                                Circle()
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .foregroundColor(value.color)
                                Text("\(value.rawValue)")
                                Spacer()
                                if let status = profile.presence.status, status == value {
                                    Image("ic_checkmark_tmp")
                                }
                            }
                        })
                        .foregroundColor(.primary)
                    }
                } header: {
                    Text("Activity Status")
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                Section {
                    //                    EnumPicker(selection: $settings.presentation.messageHistoryStyle, label: Text("Message History Style"))
                    //                        .pickerStyle(SegmentedPickerStyle())
                    Toggle(isOn: $settings.notification.enable) {
                        Text("Notifications")
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    Toggle(isOn: $settings.presentation.showChannelPreviews) {
                        Text("Show Room & Messages previews")
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    //                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    VStack {
                        Toggle(isOn: $settings.bluetooth.advertisingEnabled) {
                            
                            Text("Be discoverable by nearby users")
                            
                        }
                        HStack {
                            Text("Keep active to appear to other users. You can keep contact people even if you are not discoverable.")
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
                            Spacer(minLength: 50)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    VStack {
                        
                        Toggle(isOn: $settings.bluetooth.scanningEnabled) {
                            Text("Scan to discover nearby users")
                            
                        }
                        HStack {
                            Text("Automatically scan for people around you. We recommend to keep this feature enabled.")
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
                                Spacer(minLength: 50)
                        }
                    }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    //                    Toggle(isOn: $settings.bluetooth.monitorSignalStrength) {
                    //                        Text("Monitor signal strengths")
                    //                    }
                    if settings.bluetooth.monitorSignalStrength {
                        VStack {
                            HStack {
                                Text("Bloom monitoring interval (in seconds)")
                                Spacer()
                                TextField("sec", text: Binding(
                                    get: { String(settings.bluetooth.monitorSignalStrengthInterval) },
                                    set: {
                                        if let value = Int($0) {
                                            settings.bluetooth.monitorSignalStrengthInterval = value
                                        }
                                    }
                                ))
                                .multilineTextAlignment(.trailing)
                                .fixedSize()
                                .keyboardType(.numberPad)
                            }
                            HStack {
                                Text("Bloom checks connections regularly to ensure smooth communication. We recommend to keep this value at 5 seconds.")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 13))
                                Spacer(minLength: 50)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    }
                } header: {
                    Text("Bloom Settings")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                }
                .textCase(.none)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                .listRowBackground(Color.white.opacity(0.17))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileView_Previews: PreviewProvider {
    @StateObject static var profile = Profile()
    @StateObject static var settings = Settings()
    
    static var previews: some View {
        ProfileView()
            .environmentObject(profile)
            .environmentObject(settings)
    }
}
