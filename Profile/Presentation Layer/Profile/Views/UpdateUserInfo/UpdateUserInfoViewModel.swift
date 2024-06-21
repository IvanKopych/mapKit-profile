//
//  UpdateUserInfoViewModel.swift
//  Profile
//
//  Created by admin on 21.06.2024.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI
import Combine

final class UpdateUserInfoViewModel: ObservableObject {
    
    @Published var showPhotoPicker: Bool = false
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var name: String = "Ivan Kopych"
    @Published var description: String = "Globe-trotter, fearless adventurer, cultural enthusiast, storyteller"
    @Published var avatar: UIImage = .avatar
    
    var onSave: () -> Void
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(onSave: @escaping () -> Void) {
        self.onSave = onSave
        
        setupSubscribers()
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    // MARK: - Methods(private)

    private func setupSubscribers() {
        $selectedPhotoItem.sink { [weak self] value in
            if let value {
                self?.updateAvatar(with: value)
            }
        }
        .store(in: &subscriptions)
    }
    
    private func updateAvatar(with newAvatar: PhotosPickerItem?) {
        Task {
            if let data = try? await newAvatar?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.avatar = uiImage
                    }
                }
            } else {
                print("Failed")
            }
        }
    }
}
