//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/25.
//

import SwiftUI

struct MapViewActionButton: View {
    
    @Binding var mapViewState : MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapViewState)
            }
        } label: {
            Image(systemName: imageNameForState(mapViewState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("DEBUG: No Input")
        case .searchingForLocation:
            mapViewState = .noInput
        case .locationSelected, .polyLineAdded:
            mapViewState = .noInput
            viewModel.selectedUberLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation,.locationSelected, .polyLineAdded:
            return "arrow.left"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapViewState: .constant(.noInput))
    }
}
