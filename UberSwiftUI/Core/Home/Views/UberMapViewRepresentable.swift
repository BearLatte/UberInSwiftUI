//
//  UberMapViewRepresentable.swift
//  UberSwiftUI
//
//  Created by Tim on 2023/6/25.
//

import SwiftUI
import MapKit


struct UberMapViewRepresentable : UIViewRepresentable {
    
    let mapView = MKMapView()
    let locationManager  = LocationManager.shared
    @Binding var mapViewState : MapViewState
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled   = false
        mapView.userTrackingMode  = .follow
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("DEBUG: Map View State is \(mapViewState)")
        
        switch mapViewState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterOnUserLocation()
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = locationViewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyLine(withDestinationCoordinate: coordinate)
            }
            break
        case .polyLineAdded:
            break
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension UberMapViewRepresentable {
    
    class MapCoordinator : NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        
        var parent : UberMapViewRepresentable
        var userLocationCoordinate : CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        // MARK: - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            userLocationCoordinate = userLocation.coordinate
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 6
            return renderer
        }
        
        
        // MARK: - Helpers
        
        /// 添加大头针到地图上
        /// - Parameter coordinate: 大头针位置
        fileprivate func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            // 删除之前的
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            // 添加当前选中的
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
        }
        
        
        /// 在地图上绘制线条
        fileprivate func configurePolyLine(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocationCoordinate = self.userLocationCoordinate else { return }
            parent.locationViewModel.getDestinationRoute(from: userLocationCoordinate,
                                to: coordinate) { route in
                self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapViewState = .polyLineAdded
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect, edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setVisibleMapRect(rect, animated: true)
            }
        }
        
        /// 清除地图上的所有大头针，覆盖层并将中心移动到当前选中
        fileprivate func clearMapViewAndRecenterOnUserLocation() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
    }
}
