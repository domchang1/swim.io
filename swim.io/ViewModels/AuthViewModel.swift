//
//  AuthViewModel.swift
//  swim.io
//
//  Created by Dominic Chang on 5/21/25.
//

import SwiftData
import SwiftUI
import Foundation

// Local Authentication ViewModel
class AuthViewModel: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var isAuthenticated = false
    
    private var modelContext: ModelContext?
    
    init() {
        loadCurrentUser()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadCurrentUser()
    }
    
    private func loadCurrentUser() {
        if let userId = UserDefaults.standard.string(forKey: "currentUserId"),
           let context = modelContext {
            
            let fetchDescriptor = FetchDescriptor<AppUser>(
                predicate: #Predicate { $0.id == userId }
            )
            
            do {
                let users = try context.fetch(fetchDescriptor)
                if let user = users.first {
                    currentUser = user
                    isAuthenticated = true
                }
            } catch {
                print("Error loading user: \(error)")
            }
        }
    }
    
    func signUp(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let context = modelContext else {
            completion(false, "Database not available")
            return
        }
        
//        // Validate email format
//        guard email.contains("@") && email.contains(".") else {
//            completion(false, "Please enter a valid email address")
//            return
//        }
        
        // Validate password
        guard password.count >= 6 else {
            completion(false, "Password must be at least 6 characters")
            return
        }
        
        // Check if user already exists
        let fetchDescriptor = FetchDescriptor<AppUser>(
            predicate: #Predicate { $0.username == username }
        )
        
        do {
            let existingUsers = try context.fetch(fetchDescriptor)
            if !existingUsers.isEmpty {
                completion(false, "An account with this email already exists")
                return
            }
            
            // Create new user
            let passwordHash = hashPassword(password)
            let newUser = AppUser(passwordHash: passwordHash, username: username)
            context.insert(newUser)
            try context.save()
            
            // Log in the user
            currentUser = newUser
            isAuthenticated = true
            UserDefaults.standard.set(newUser.id, forKey: "currentUserId")
            
            completion(true, nil)
        } catch {
            completion(false, "Failed to create account: \(error.localizedDescription)")
        }
    }
    
    func signIn(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let context = modelContext else {
            completion(false, "Database not available")
            return
        }
        
        let fetchDescriptor = FetchDescriptor<AppUser>(
            predicate: #Predicate { $0.username == username }
        )
        
        do {
            let users = try context.fetch(fetchDescriptor)
            guard let user = users.first else {
                completion(false, "No account found with this email")
                return
            }
            
            if verifyPassword(password, hash: user.passwordHash) {
                currentUser = user
                isAuthenticated = true
                UserDefaults.standard.set(user.id, forKey: "currentUserId")
                completion(true, nil)
            } else {
                completion(false, "Incorrect password")
            }
        } catch {
            completion(false, "Login failed: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }
    
    private func hashPassword(_ password: String) -> String {
        // Simple hash for development - in production use proper hashing
        return String(password.hashValue)
    }
    
    private func verifyPassword(_ password: String, hash: String) -> Bool {
        return String(password.hashValue) == hash
    }
}
