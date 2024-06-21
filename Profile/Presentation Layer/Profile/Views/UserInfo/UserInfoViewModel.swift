//
//  UserInfoViewModel.swift
//  Profile
//
//  Created by admin on 19.06.2024.
//

import Foundation
import UIKit
import Combine

final class UserInfoViewModel: ObservableObject {
    
    @Published var numberOfVisitedCountries: Int = .zero
    @Published var percentageOfVisitedCountries: Int = .zero
    @Published var showPhotoPicker: Bool = false
    @Published var userName: String = "Ivan Kopych"
    @Published var description: String = "Globe-trotter, fearless adventurer, cultural enthusiast, storyteller"
    @Published var avatar: UIImage = .avatar
    @Published var updateUserInfoViewModel = UpdateUserInfoViewModel(onSave: {})
    
    var onEdit: () -> Void
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(onEdit: @escaping () -> Void) {
        self.onEdit = onEdit
    }
    
    // MARK: - Methods(Public)
    
    func calculateNumberOfVisitedCountries(for countries: [Country]) {
        numberOfVisitedCountries = countries.filter({ $0.isVisited == true }).count
    }
    
    func calculatePercentageOfVisitedCountries(for countries: [Country]) {
        let numberOfVisitedCountries = countries.filter({ $0.isVisited == true }).count
        percentageOfVisitedCountries = (numberOfVisitedCountries * 100) / countries.count
    }
    
    func updateAvatar(for image: UIImage) {
        avatar = image
    }
    
    func updateUserName(for name: String) {
        userName = name
    }
    
    func updateDecription(for text: String) {
        description = text
    }
}
