//
//  RideRequestView.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/29.
//

import SwiftUI

struct RideRequestView: View {
    
    @State private var selectedRideType : RideType = .uberX
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            // Trip info view
            HStack {
                
                // indicator view
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                }
                
                
                //
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Current Location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(locationViewModel.pickupTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            
                            if let uberLocation = locationViewModel.selectedUberLocation {
                                Text(uberLocation.title)
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            
                            Spacer()
                                
                            Text(locationViewModel.dropOffTime ?? "")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            
            // ride type selection view
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RideType.allCases) { type in
                        VStack(alignment: .leading) {
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(type.description)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text(locationViewModel.computeRidePrice(forType: type).toCurrency())
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(.leading)
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(type == selectedRideType ? .white : Color.theme.primaryTextColor)
                        .background(type == selectedRideType ? Color(.systemBlue) : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedRideType ? 1.2 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRideType = type
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
        
            // payment option view
            HStack(spacing: 12) {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(Color.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** **** **** 0302")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            
            // request ride button
            Button {
                
            } label: {
                Text("confirm ride".uppercased())
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 35)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
    }
}

struct RideRequestView_Previews: PreviewProvider {
    static var previews: some View {
        RideRequestView()
    }
}

