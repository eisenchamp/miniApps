import UIKit

class WeatherMiniAppView: UIView {
    
    let weatherLabel = UILabel()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        fetchWeather()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        fetchWeather()
    }
    
    private func setupUI() {
        backgroundColor = .lightGray
        
        weatherLabel.text = "Weather"
        weatherLabel.textColor = .black
        weatherLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        
        temperatureLabel.text = "Loading..."
        temperatureLabel.textColor = .black
        temperatureLabel.font = UIFont.systemFont(ofSize: 16)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weatherLabel)
        addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            weatherLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5)
        ])
    }
    
    private func fetchWeather() {
        let temperature = "22°C / 72°F"
        temperatureLabel.text = "Temperature: \(temperature)"
    }
}
