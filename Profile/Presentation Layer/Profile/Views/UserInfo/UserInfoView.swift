//
//  UserInfoView.swift
//  Profile
//
//  Created by admin on 19.06.2024.
//

import SwiftUI

struct UserInfoView: View {
    
    @StateObject var viewModel: UserInfoViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 20) {
                avatar
                    .onTapGesture {
                        viewModel.showPhotoPicker.toggle()
                    }
                info
                    .offset(y: 15)
            }
            .padding(.horizontal, 26)
            
            score
        }
    }
    
    private var avatar: some View {
        Color.white
            .frame(width: 90, height: 90)
            .clipShape(Circle())
            .overlay {
                Image(uiImage: viewModel.avatar)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }
    }
    
    private var info: some View {
        VStack(spacing: .zero) {
            HStack {
                Text(viewModel.userName)
                    .font(.title3.bold())
                
                Button(action: {
                    viewModel.onEdit()
                }, label: {
                    Image(systemName: "highlighter")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black)
                })
                .frame(width: 40, height: 40)
                
                Spacer()
            }
            
            HStack {
                Text(viewModel.description)
                    .font(.caption)

                Spacer()
            }
        }
    }
    
    private var score: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("\(viewModel.numberOfVisitedCountries)")
                        .font(.title)
                    
                    Text("countries")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Rectangle()
                    .frame(width: 0.1, height: 35)
                    .foregroundStyle(.gray)
                    
                Spacer()
                
                VStack {
                    Text("\(viewModel.percentageOfVisitedCountries)%")
                        .font(.title)

                    Text("world")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                Spacer()
            }
            
            Divider()
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    UserInfoView(viewModel: UserInfoViewModel(onEdit: {}))
}
