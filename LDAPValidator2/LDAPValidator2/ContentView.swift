//
//  ContentView.swift
//  LDAPValidator2
//
//  Created by Joseph Noonan on 1/30/25.
//

import SwiftUI
import GRPC

struct ContentView: View {
    @StateObject private var viewModel = ValidationViewModel()
    
    var body: some View {
        Form {
            Section {
                Picker("Authentication Type", selection: $viewModel.selectedAuthType) {
                    ForEach(ValidationViewModel.AuthType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                TextField("User ID", text: $viewModel.userId)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $viewModel.password)
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.validateCredentials()
                    }
                }) {
                    if viewModel.isValidating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Validate")
                    }
                }
                .disabled(viewModel.userId.isEmpty || viewModel.password.isEmpty || viewModel.isValidating)
                
                if !viewModel.validationResult.isEmpty {
                    Text(viewModel.validationResult)
                        .foregroundColor(viewModel.validationResult.contains("Successful") ? .green : .red)
                }
                
                if !viewModel.phoneNumber.isEmpty {
                    Text("Phone: \(viewModel.phoneNumber)")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
