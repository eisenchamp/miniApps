import UIKit
import CoreLocation

class CityInfoViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let flagImageView = UIImageView()
    let cityLabel = UILabel()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupUI()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setupUI() {
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.text = "Fetching city info..."
        cityLabel.textColor = .white
        cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.numberOfLines = 0
        cityLabel.lineBreakMode = .byWordWrapping

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(flagImageView)
        stackView.addArrangedSubview(cityLabel)
        
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        fetchCityInfo(latitude: latitude, longitude: longitude)
        
        locationManager.stopUpdatingLocation()
    }

    func fetchCityInfo(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Failed to get city info: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first else { return }

            let city = placemark.locality ?? "Unknown City"
            let country = placemark.country ?? "Unknown Country"
            let countryCode = placemark.isoCountryCode ?? "us" // Default to 'us' if not available

            DispatchQueue.main.async {
                self.cityLabel.text = "City: \(city) \nCountry: \(country) \nLatitude: \(latitude) \nLongitude: \(longitude)"
                self.fetchCountryFlag(countryCode: countryCode)
            }
        }
    }

    func fetchCountryFlag(countryCode: String) {
        let flagURL = "https://flagcdn.com/w320/\(countryCode.lowercased()).png"
        guard let url = URL(string: flagURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch flag: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self.flagImageView.image = image
            }
        }.resume()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied.")
        default:
            break
        }
    }
}
