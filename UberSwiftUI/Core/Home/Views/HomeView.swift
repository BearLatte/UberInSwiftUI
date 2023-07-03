//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var mapViewState = MapViewState.noInput
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapViewState: $mapViewState)
                    .ignoresSafeArea()
                
                if mapViewState == .searchingForLocation {
                    LocationSearchView(mapViewState: $mapViewState)
                } else if mapViewState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapViewState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapViewState: $mapViewState)
                    .padding(.leading, 25)
                    .padding(.top, 4)
                
            }
            
            if mapViewState == .locationSelected  || mapViewState == .polyLineAdded {
                RideRequestView()
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                    .ignoresSafeArea()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
