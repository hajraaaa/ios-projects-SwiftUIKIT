import Foundation

struct City :Decodable{
    let city: String
    let country: String
}

struct CityResponse :Decodable{
    let data: [City]
}

