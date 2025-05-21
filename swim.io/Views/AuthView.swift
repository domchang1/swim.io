//
//  AuthView.swift
//  swim.io
//
//  Created by Dominic Chang on 5/21/25.
//

import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    @State private var showingError = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // App logo/branding
                Image(systemName: "figure.pool.swim")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                Text("Swim.io")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Form fields
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                // Sign in/up button
                Button {
                    if isSignUp {
                        authViewModel.signUp(email: email, password: password) { success, error in
                            if !success, let error = error {
                                errorMessage = error
                                showingError = true
                            }
                        }
                    } else {
                        authViewModel.signIn(email: email, password: password) { success, error in
                            if !success, let error = error {
                                errorMessage = error
                                showingError = true
                            }
                        }
                    }
                } label: {
                    Text(isSignUp ? "Create Account" : "Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Toggle between sign in/up
                Button {
                    isSignUp.toggle()
                    // Clear fields when switching modes
                    email = ""
                    password = ""
                    errorMessage = ""
                } label: {
                    Text(isSignUp ? "Already have an account? Sign in" : "Don't have an account? Create one")
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding(.top, 50)
            .navigationBarHidden(true)
            .alert(isPresented: $showingError) {
                Alert(
                    title: Text("Authentication Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

