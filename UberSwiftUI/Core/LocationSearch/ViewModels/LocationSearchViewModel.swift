//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/26.
//

import Foundation
import MapKit

class LocationSearchViewModel : NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation : UberLocation?
    @Published var pickupTime  : String?
    @Published var dropOffTime : String?
    
    var userLocation : CLLocationCoordinate2D?
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

// MARK: - Helper

extension LocationSearchViewModel {
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                return print("DEBUG: Local search faild with error \(error.localizedDescription)")
            }
            
            guard let mapItem = response?.mapItems.first else { return }
            let coordinate = mapItem.placemark.coordinate
            self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let destCoordinate = self.selectedUberLocation?.coordinate else { return 0 }
        guard let userCoordinate = self.userLocation else { return 0 }
        
        let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let destLocation = CLLocation(latitude: destCoordinate.latitude, longitude: destCoordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destLocation)
        
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    /// 获取从当前位置到目的地的路径
    /// - Parameters:
    ///   - userLocation: 当前定位经纬度
    ///   - destination: 目的地定位经纬度
    ///   - completionHandler: 完成后的回调
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                                         to destination: CLLocationCoordinate2D,
                                         completionHandler: @escaping (MKRoute) -> Void) {
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            if let error = error {
                return print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
            }
            
            guard let route = response?.routes.first else { return }
            self.configurePickupDropoffTimes(with: route.expectedTravelTime)
            completionHandler(route)
        }
    }
    
    func configurePickupDropoffTimes(with expectedTravalTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravalTime)
    }
}
