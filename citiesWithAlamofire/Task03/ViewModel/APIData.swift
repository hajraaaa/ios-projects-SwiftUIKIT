import Alamofire
import Foundation

protocol APIDataDelegate: AnyObject {
    func didUpdateData()
    func didFailWithError(_ error: Error)
}

class APIData {
    weak var delegate: APIDataDelegate?
    
    private var cities: [City] = []
    private(set) var filteredCities: [City] = []
    private(set) var groupedCities = [String: [City]]()
    
    func fetchCities() {
        let url = "https://countriesnow.space/api/v0.1/countries/population/cities"
        
        AF.request(url).responseDecodable(of: CityResponse.self) { response in
            switch response.result {
            case .success(let cityResponse):
                self.cities = cityResponse.data
                self.filterAndGroupCities(searchText: "")
                DispatchQueue.main.async {
                    self.delegate?.didUpdateData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
    
    func filterAndGroupCities(searchText: String) {
        if searchText.isEmpty {
            filteredCities = cities
        } else {
            filteredCities = cities.filter {
                $0.city.lowercased().hasPrefix(searchText.lowercased()) ||
                $0.country.lowercased().hasPrefix(searchText.lowercased())
            }
        }
        
        groupedCities.removeAll()
        for city in filteredCities {
            groupedCities[city.country, default: []].append(city)
        }
        
        delegate?.didUpdateData()
    }
    
    func numberOfSections() -> Int {
        return groupedCities.keys.count
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        let countryName = Array(groupedCities.keys)[section]
        return groupedCities[countryName]?.count ?? 0
    }
    
    func countryName(forSection section: Int) -> String {
        return Array(groupedCities.keys)[section]
    }
    
    func city(for indexPath: IndexPath) -> City {
        let countryName = countryName(forSection: indexPath.section)
        return groupedCities[countryName]?[indexPath.row] ?? City(city: "", country: "")
    }
}
