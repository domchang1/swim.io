//
//  HomeView.swift
//  swim.io
//
//  Created by Dominic Chang on 2/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppViewModel())
}
