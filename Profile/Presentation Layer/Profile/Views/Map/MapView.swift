//
//  MapView.swift
//  Profile
//
//  Created by admin on 18.06.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var countries: [Country]
    
    @State private var region = MKCoordinateRegion()
    @State var camera: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $camera) {
            ForEach(countries, id: \.id) { country in
                if let coordinate = country.coordinate {
                    Annotation(country.name, coordinate: coordinate, content: {
                        anotation(country)
                    })
                }
            }
        }
        .mapStyle(.hybrid(elevation: .realistic))
    }
    
    private func anotation(_ country: Country) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: -6) {
                Text(country.flag)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(8)
                
                Triangle()
                    .stroke(.white, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(.white)
                    .frame(width: 20)
                    
            }
            
            if country.isVisited {
                Color.white
                    .frame(width: 17, height: 17)
                    .clipShape(Circle())
                    .overlay {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundStyle(Color("blue1"))
                            .background(.white)
                            .clipShape(Circle())
                            
                    }
                    .padding(.top , -5)
                    .padding(.trailing , -5)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(countries: .constant([]))
    }
}
