//
//  ContentView.swift
//  Profile
//
//  Created by admin on 18.06.2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}

#Preview {
    ContentView()
}
