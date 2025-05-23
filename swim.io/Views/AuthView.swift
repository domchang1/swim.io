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
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var isLoading = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // App branding
                    VStack(spacing: 10) {
                        Image(systemName: "figure.pool.swim")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                        
                        Text("Swim.io")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(isSignUp ? "Create your account" : "Welcome back")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Form fields
                    VStack(spacing: 16) {
                        if isSignUp {
                            HStack(spacing: 12) {
                                TextField("First Name", text: $firstName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("Last Name", text: $lastName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    // Action button
                    Button {
                        handleAuthentication()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text(isSignUp ? "Create Account" : "Sign In")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        (email.isEmpty || password.isEmpty) ? Color.gray : Color.blue
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .disabled(email.isEmpty || password.isEmpty || isLoading)
                    
                    // Toggle sign in/up
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSignUp.toggle()
                            clearFields()
                        }
                    } label: {
                        Text(isSignUp ? "Already have an account? Sign in" : "Don't have an account? Create one")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showingError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleAuthentication() {
        isLoading = true
        
        if isSignUp {
            authViewModel.signUp(
                email: email,
                password: password,
                firstName: firstName.isEmpty ? nil : firstName,
                lastName: lastName.isEmpty ? nil : lastName
            ) { success, error in
                isLoading = false
                if !success, let error = error {
                    errorMessage = error
                    showingError = true
                }
            }
        } else {
            authViewModel.signIn(email: email, password: password) { success, error in
                isLoading = false
                if !success, let error = error {
                    errorMessage = error
                    showingError = true
                }
            }
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
        firstName = ""
        lastName = ""
        errorMessage = ""
    }
}

