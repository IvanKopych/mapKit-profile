//
//  ItemListView.swift
//  Profile
//
//  Created by admin on 19.06.2024.
//

import SwiftUI

struct ItemListView: View {
    
    var type: ListType
    @Binding var countries: [Country]
    var onAdd: () -> Void
    
    @State private var showMore: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text(type == .visited ? "I’ve been to" : "My bucket list")
                    .font(.system(size: 17).bold())
                
                Spacer()
                
                Button(action: {
                    onAdd()
                }, label: {
                    HStack {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color("purle1"))
                        
                        Text("Add country")
                            .font(.system(size: 15).bold())
                            .foregroundStyle(Color("purle1"))
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
                    .background(.background.secondary)
                    .cornerRadius(20)
                })
            }
            .padding(.horizontal, 26)
             
            if countries.filter({ type == .visited ? $0.isVisited == true : $0.isAddedToBucketList == true }).count == 0 {
                emptyState
                    .padding(.horizontal, 26)
            } else {
                let numberOfItems = countries.filter({ type == .visited ? $0.isVisited == true : $0.isAddedToBucketList == true }).count
                ForEach(countries.filter({ type == .visited ? $0.isVisited == true : $0.isAddedToBucketList == true }).prefix(showMore ? (numberOfItems) : 3), id: \.id) { country in
                    itemView(country: country)
                }
                if numberOfItems > 3 {
                    seaMoreButtom(numberOfItems: numberOfItems - 3)
                }
            }
        }
    }
    
    private var emptyState: some View {
        if type == .visited {
            VStack(spacing: 20) {
                Text("🧳")
                    .font(.system(size: 50))
                Text("Share the countries you’ve had the joy of visiting!")
                    .multilineTextAlignment(.center)
            }
        } else {
            VStack(spacing: 20) {
                Text("✈️")
                    .font(.system(size: 50))
                Text("Choose a country you’d love to visit!")
                    .multilineTextAlignment(.center)
            }
        }
    }
    private func seaMoreButtom(numberOfItems: Int) -> some View {
        Button(action: {
            withAnimation {
                showMore.toggle()
            }
        }, label: {
            HStack {
                Image(systemName: showMore ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.gray)
                Text(showMore ? "See less" : "See \(numberOfItems) more")
                    .font(.system(size: 17))
                    .foregroundStyle(.gray)
                
                Spacer()
            }
        })
        .padding(.horizontal, 26)
    }
    
    private func itemView(country: Country) -> some View {
        VStack {
            HStack {
                Text(country.flag)
                Text(country.name)
                    .font(.system(size: 17))
                
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal, 26)
        }
    }
}

#Preview {
    ItemListView(type: .visited, countries: .constant([]), onAdd: {})
}
