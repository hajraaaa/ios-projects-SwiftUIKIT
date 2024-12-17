import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://dummyjson.com"
    
    private init() {}

    func get<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL + endpoint
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
