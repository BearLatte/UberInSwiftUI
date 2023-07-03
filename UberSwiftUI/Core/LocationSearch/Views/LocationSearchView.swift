//
//  LocationSearchView.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/25.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var statLocationText  : String = ""
    @Binding var mapViewState : MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var body: some View {
        ZStack {
            Color.theme.backgroundColor.ignoresSafeArea()
            
            VStack {
                // header view
                HStack {
                    VStack {
                        Circle()
                            .fill(Color(.systemGray3))
                            .frame(width: 6, height: 6)
                        
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 24)
                        
                        Rectangle()
                            .fill(.black)
                            .frame(width: 6, height: 6)
                    }
                    
                    VStack {
                        TextField("Current Location", text: $statLocationText)
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))
                        
                        TextField("Where to?", text: $viewModel.queryFragment)
                            .frame(height: 32)
                            .background(Color(.systemGray4))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 64)
                
                Divider()
                    .padding(.vertical)
                
                // list view
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.results, id: \.self) { result in
                            LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        withAnimation(.spring()) {
                                            viewModel.selectLocation(result)
                                            mapViewState = .locationSelected
                                        }
                                        
                                    }
                                }
                        }
                    }
                }
            }
        }
        
        
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapViewState: .constant(.noInput))
    }
}
