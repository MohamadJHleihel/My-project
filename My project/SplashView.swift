//
//  SplashView.swift
//  My project
//
//  Created by Mohamad Hleihel on 2023-12-24.
//


import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationView {
        
            VStack{
                
                Image("Logo 1")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipped()
                
                
                
                Text("Thank you for using Medecine tracker")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                Text("              .This app is a simple application that helps you remember when to take your medicines. The app offers notifications when registering a medicine with either 2 times (8 hours apart) or 3 times (6 hours apart). ")
                
                    .foregroundStyle(.gray)
                    
                Text("              .It does not store your data anywhere outside your device.")
                   
                    .foregroundStyle(.gray)
                Text("              .The app does not conduct any health-related research nor provide you with any medical advice. The frequencies of medicine intake are only set by the user and should be decided by doctors.")
            
                    .foregroundStyle(.gray)
                VStack{
                
                NavigationLink (destination: ContentView()) {
                    Text("Open tracker")
                }
            }
            .padding()
            .navigationTitle("")
                
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            
            .background(.mint)
           
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SplashView()
}

