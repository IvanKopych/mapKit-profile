//
//  ProfileViewModel.swift
//  Profile
//
//  Created by admin on 18.06.2024.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

final class ProfileViewModel: ObservableObject {
    
    // MARK: - Published

    @MainActor @Published var countries: [Country] = []
    @Published var selectVisitedCountries: Bool = false
    @Published var selectVisitInFutureCountries: Bool = false
    @Published var showUpdateUserInfo: Bool = false
    @Published var userInfoViewModel = UserInfoViewModel(onEdit: {})
    @Published var updateUserInfoViewModel = UpdateUserInfoViewModel(onSave: {})
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        setupActions()
    }
    
    // MARK: - Methods(Private)
    
    private func setupActions() {
        userInfoViewModel.onEdit = { [weak self] in
            self?.showUpdateUserInfo.toggle()
        }
        
        updateUserInfoViewModel.onSave = { [weak self] in
            self?.showUpdateUserInfo.toggle()
        }
    }
    
    private func setupSubscribers() {
        $selectVisitedCountries.sink { value in
            if !value {
                Task {
                    await self.fetchLocationsForVisitedCountries()
                }
            }
        }
        .store(in: &subscriptions)
        
        $selectVisitInFutureCountries.sink { value in
            if !value {
                Task {
                    await self.fetchLocationsForBucketListCountries()
                }
            }
        }
        .store(in: &subscriptions)
        
        $countries.sink { [weak self] value in
            if !value.isEmpty {
                self?.updateUserInfo(value)
            }
        }
        .store(in: &subscriptions)
        
        $showUpdateUserInfo.sink { [weak self] value in
            if !value {
                self?.updateUserInfo()
            }
        }
        .store(in: &subscriptions)
        
    }
    
    private func updateUserInfo() {
        userInfoViewModel.updateUserName(for: updateUserInfoViewModel.name)
        userInfoViewModel.updateDecription(for: updateUserInfoViewModel.description)
        userInfoViewModel.updateAvatar(for: updateUserInfoViewModel.avatar)
    }
    
    
    private func updateUserInfo(_ countries: [Country]) {
        userInfoViewModel.calculateNumberOfVisitedCountries(for: countries)
        userInfoViewModel.calculatePercentageOfVisitedCountries(for: countries)
    }

    private func getCountryFlag(_ country: String) -> String {
        country
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    private func getCordinate(address: String) async -> CLLocationCoordinate2D  {
        let geocoder = CLGeocoder()
        var location: CLLocation?
        
        let placemarks = try? await geocoder.geocodeAddressString(address)
        
        if let placemarks = placemarks, placemarks.count > 0 {
            location = placemarks.first?.location
        }
        
        if let location = location {
            let coordinate = location.coordinate
            return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        } else {
            print("No Matching Location Found for ---- \(address)")
            return CLLocationCoordinate2D(latitude: .zero, longitude: .zero)
        }
    }
    
    private func fetchLocationsForVisitedCountries() async {
        await withTaskGroup(of: Void.self) { group in
            if await countries.count > 0 {
                for index in await 0..<countries.count {
                    if await self.countries[index].isVisited {
                        group.addTask {
                            let coordinate = await self.getCordinate(address: self.countries[index].name)
                            await MainActor.run {
                                withAnimation {
                                    self.countries[index].coordinate = coordinate
                                }
                                
                            }
                        }
                        
                        for await loacation in group {
                            print(loacation)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchLocationsForBucketListCountries() async {
        await withTaskGroup(of: Void.self) { group in
            if await countries.count > 0 {
                for index in await 0..<countries.count {
                    if await self.countries[index].isAddedToBucketList {
                        group.addTask {
                            let coordinate = await self.getCordinate(address: self.countries[index].name)
                            await MainActor.run {
                                withAnimation {
                                    self.countries[index].coordinate = coordinate
                                }
                                
                            }
                        }
                        
                        for await loacation in group {
                            print(loacation)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Methods(Public)
    
    func fetchCountries() async {
        let countries = Locale.Region.isoRegions.filter { $0.subRegions.isEmpty }.map { $0.identifier }.sorted()
            .compactMap {
                Country(
                    id: $0,
                    name: countryName(from: $0),
                    flag: getCountryFlag($0))
            }
        
        await MainActor.run {
            self.countries = countries
        }
    }
    
    func countryName(from countryCode: String) -> String {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: countryCode) ?? ""
    }
}
