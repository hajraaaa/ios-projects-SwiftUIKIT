//
//  viewControllerVM.swift
//  Task03
//
//  Created by RAI on 30/08/2024.
//

import Foundation
import Alamofire

class ViewControllerVM {
    
        func fetchData() {
            let url = "https://countriesnow.space/api/v0.1/countries/population/cities"
            AF.request(url).responseDecodable(of: CityResponse.self) { response in
                
                switch response.result {
                case .success(let cityResponse):
                    self.cities = cityResponse.data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
}
