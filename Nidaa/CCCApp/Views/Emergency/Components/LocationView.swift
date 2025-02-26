import SwiftUI
import MapKit

struct LocationView: View {
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map {
            Marker("Emergency Location", coordinate: coordinate)
        }
    }
} 