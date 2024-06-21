//
//  CountriesSelectionView.swift
//  Profile
//
//  Created by admin on 19.06.2024.
//

import SwiftUI

struct CountriesSelectionView: View {
    
    var type: ListType
    @Binding var countries: [Country]
    @State var text: String = ""
    
    var onDone: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    onDone()
                } label: {
                    Text("Done")
                        .font(.system(size: 17).bold())
                }
            }
            .padding()
            
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22))
                    .foregroundStyle(.gray)
                
                TextField("Search country", text: $text)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(.gray.opacity(0.2))
            .cornerRadius(15)
            .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(countries.indices, id: \.self) { index in
                        switch type {
                        case .visited:
                            if !countries[index].isAddedToBucketList {
                                countryItem(countries[index])
                                    .onTapGesture {
                                        if countries[index].isVisited {
                                            countries[index].coordinate = nil
                                        }
                                        countries[index].isVisited.toggle()
                                    }
                            }
                            
                        case .visitInFuture:
                            if !countries[index].isVisited {
                                countryItem(countries[index])
                                    .onTapGesture {
                                        if countries[index].isAddedToBucketList {
                                            countries[index].coordinate = nil
                                        }
                                        countries[index].isAddedToBucketList.toggle()
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func countryItem(_ country: Country) -> some View {
        VStack {
            if (text.isEmpty ? countries : countries.filter({ $0.name.lowercased().contains(text.lowercased())})).firstIndex(where: { $0.id == country.id }) != nil {
                
                HStack {
                    Text(country.flag)
                    Text(country.name)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    switch type {
                    case .visited:
                        if country.isVisited {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color("blue1"))
                                .background(.white)
                                .clipShape(Circle())
                        }
                    case .visitInFuture:
                        if country.isAddedToBucketList {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color("blue1"))
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 8)
                .background(.white)
                
                Divider()
                    .padding(.horizontal, 26)
            }
        }
    }
}

#Preview {
    CountriesSelectionView(type: .visitInFuture, countries: .constant([]), onDone: {})
}
