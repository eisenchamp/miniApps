import UIKit

class CityInfoMiniAppView: UIView {
    
    let cityLabel = UILabel()
    let flagImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        fetchCityInfo()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        fetchCityInfo()
    }
    
    private func setupUI() {
        backgroundColor = .lightGray
        
        cityLabel.text = "City Info"
        cityLabel.textColor = .black
        cityLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cityLabel.numberOfLines = 0
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cityLabel)
        addSubview(flagImageView)
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            flagImageView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            flagImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            flagImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            flagImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func fetchCityInfo() {
        // Assuming you have a method to fetch city info data
        let city = "San Francisco"
        let country = "USA"
        let flagURL = "https://flagcdn.com/w320/us.png"
        
        cityLabel.text = "City: \(city)\nCountry: \(country)"
        
        // Load flag image
        if let url = URL(string: flagURL) {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.flagImageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
