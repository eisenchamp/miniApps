import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let apiKey = "9067ca76b6090959680fb51ac8fa9733"
    let weatherLabel = UILabel()

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
        weatherLabel.text = "Fetching weather..."
        weatherLabel.textColor = .white
        weatherLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.numberOfLines = 0
        weatherLabel.lineBreakMode = .byWordWrapping

        view.addSubview(weatherLabel)

        NSLayoutConstraint.activate([
            weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weatherLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        fetchWeather(latitude: latitude, longitude: longitude)
        
        locationManager.stopUpdatingLocation()
    }

    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch weather: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let main = json["main"] as? [String: Any],
                   let temperatureMetric = main["temp"] as? Double,
                   let name = json["name"] as? String {
                    let temperatureFahrenheit = (temperatureMetric * 9/5) + 32

                    DispatchQueue.main.async {
                        self.weatherLabel.text = """
                        City: \(name)
                        Temperature: \(String(format: "%.1f", temperatureMetric))°C
                        Temperature: \(String(format: "%.1f", temperatureFahrenheit))°F
                        """
                    }
                }
            } catch let error {
                print("Failed to parse JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
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
