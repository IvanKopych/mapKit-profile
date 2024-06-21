//
//  UpdateUserInfoView.swift
//  Profile
//
//  Created by admin on 21.06.2024.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Combine

struct UpdateUserInfoView: View {
    
    @StateObject var viewModel: UpdateUserInfoViewModel
    
    private let nameLenghtLimit = 25
    private let descriptionLenghtLimit: Int = 150
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                Button {
                    viewModel.onSave()
                } label: {
                    Text("Save")
                        .font(.system(size: 17).bold())
                }
            }
            .padding()
            
            ZStack(alignment: .bottomTrailing) {
                avatar
                    
                Image(systemName: "highlighter")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black)
            }
            . onTapGesture {
                viewModel.showPhotoPicker.toggle()
        }
            
            VStack(alignment: .leading, spacing: .zero) {
                Text("Your name")
                    .padding(.horizontal)
                
                TextField("Name", text: $viewModel.name)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 15)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding()
                    .onReceive(Just(viewModel.name)) { _ in limitText(nameLenghtLimit) }
                    
            }
            
            VStack(alignment: .leading, spacing: .zero) {
                Text("About you")
                    .padding(.horizontal)
                TextEditor(text: $viewModel.description)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 15)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding()
                    .onChange(of: viewModel.description) { result in
                        viewModel.description = String(viewModel.description.prefix(descriptionLenghtLimit))
                    }
            }
        }
        .photosPicker(isPresented: $viewModel.showPhotoPicker, selection: $viewModel.selectedPhotoItem, matching: .images, photoLibrary: .shared())
        
    }
    
    private var avatar: some View {
        Color.white
            .frame(width: 160, height: 160)
            .clipShape(Circle())
            .overlay {
                Image(uiImage: viewModel.avatar)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }
    }
    
    private func limitText(_ upper: Int) {
        if viewModel.name.count > upper {
            viewModel.name = String(viewModel.name.prefix(upper))
        }
    }
}

#Preview {
    UpdateUserInfoView(viewModel: UpdateUserInfoViewModel(onSave: {}))
}
