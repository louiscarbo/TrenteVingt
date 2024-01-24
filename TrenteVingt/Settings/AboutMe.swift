//
//  AboutMe.swift
//  TrenteVingt
//
//  Created by Louis Carbo Estaque on 24/01/2024.
//

import SwiftUI

struct AboutMe: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image("about-me")
                    .resizable()
                    .scaledToFit()
                VStack(alignment: .leading) {
                    Text("Hi, I'm Louis 👋")
                        .font(.title)
                        .bold()
                    Text("I'm a French 🇫🇷 Engineering student passionate about app development! ")
                        .padding(.bottom)
                    Text("Thank you so much for using TrenteVingt! This app is a personal project that allows me to learn iOS app development.")
                        .padding(.bottom)
                    Text("I'm constantly improving, and so does TrenteVingt! If you have any suggestion, feel free to contact me!")
                        .padding(.bottom)
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                let mailTo = String(localized: "mailto:TrenteVingt@carbo-estaque.fr?subject=TrenteVingt Feedback").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                let mailToUrl = URL(string: mailTo!)!
                                if UIApplication.shared.canOpenURL(mailToUrl) {
                                    UIApplication.shared.open(mailToUrl, options: [:])
                                }
                            } label: {
                                Label("Contact me", systemImage: "message")
                            }
                            .buttonStyle(.borderedProminent)
                            Button {
                                let linkedIn = String(localized: "https://www.linkedin.com/in/louis-carbo-estaque").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                let linkedinURL = URL(string: linkedIn!)!
                                if UIApplication.shared.canOpenURL(linkedinURL) {
                                    UIApplication.shared.open(linkedinURL, options: [:])
                                }
                            } label: {
                                HStack {
                                    Image("linkedin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    Text("LinkedIn")
                                }
                            }
                            .tint(Color(red: 57/255, green: 102/255, blue: 173/255))
                            .buttonStyle(.borderedProminent)
                            Button {
                                let github = String(localized: "https://github.com/louiscarbo").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                let githubURL = URL(string: github!)!
                                if UIApplication.shared.canOpenURL(githubURL) {
                                    UIApplication.shared.open(githubURL, options: [:])
                                }
                            } label: {
                                HStack {
                                    Image("github")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                    Text("Github")
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.black)
                        }
                        Spacer()
                    }
                    
                }
                .offset(y: -120)
                .padding()
            }
        }
    }
}

#Preview {
    Button("See sheet") {
    }
    .sheet(isPresented: .constant(true), content: {
        AboutMe()
    })
}

