//
//  ProfileView.swift
//  Profile
//
//  Created by admin on 18.06.2024.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    @State var offset: CGFloat = .zero
    
    var body: some View {
        ZStackLayout(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            GeometryReader { reader in
                MapView(countries: $viewModel.countries)
                    .task {
                        await viewModel.fetchCountries()
                    }
                .ignoresSafeArea(.all, edges: .all)
                .frame(height: (reader.size.height / 2) + offset)
            
                VStack {
                    info
                        .frame(height: (reader.size.height / 2) - offset)
                        .offset(y: reader.frame(in: .global).height - (reader.size.height / 2))
                        .offset(y: offset)
                        .gesture(DragGesture().onChanged({ value in
                            withAnimation {
                                if value.startLocation.y > reader.frame(in: .global).midX - 10 {
                                    if value.translation.height < -21 && offset > (-reader.frame(in: .global).height + (reader.size.height / 2)) {
                                        offset = value.translation.height
                                    }
                                }
                                
                                if value.startLocation.y < reader.frame(in: .global).midX {
                                    if value.translation.height > -21 && offset < 0 {
                                        offset = (-reader.frame(in: .global).height + (reader.size.height / 2)) + value.translation.height
                                    }
                                }
                            }
                        }).onEnded({ value in
                            withAnimation {
                                if value.startLocation.y > reader.frame(in: .global).midX {
                                    if -value.translation.height > reader.frame(in: .global).midX {
                                        offset = (-reader.frame(in: .global).height + (reader.size.height / 2)) + 150
                                        return
                                    }
                                    offset = 0
                                }
                                
                                if value.startLocation.y < reader.frame(in: .global).midX {
                                    if value.translation.height < reader.frame(in: .global).midX {
                                        offset = (-reader.frame(in: .global).height + (reader.size.height / 2)) + 150
                                        return
                                    }
                                    offset = 0
                                }
                            }
                        }))
                }
            }
        }
        .sheet(isPresented: $viewModel.selectVisitedCountries, content: {
            CountriesSelectionView(type: .visited, countries: $viewModel.countries)
        })
        .sheet(isPresented: $viewModel.selectVisitInFutureCountries, content: {
            CountriesSelectionView(type: .visitInFuture, countries: $viewModel.countries)
        })
        .sheet(isPresented: $viewModel.showUpdateUserInfo, content: {
            UpdateUserInfoView(viewModel: viewModel.updateUserInfoViewModel)
        })
    }
    
    private var info: some View {
        VStack {
            VStack {
                UserInfoView(viewModel: viewModel.userInfoViewModel)
                    .offset(y: -20)
                
            }
            .background(.white)
            
            ScrollView(.vertical) {
                LazyVStack {
                    ItemListView(type: .visited, countries: $viewModel.countries) {
                        viewModel.selectVisitedCountries.toggle()
                    }
                    
                    ItemListView(type: .visitInFuture, countries: $viewModel.countries) {
                        viewModel.selectVisitInFutureCountries.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
