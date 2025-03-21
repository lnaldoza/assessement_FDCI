//
//  CountriesViewModel.swift
//  assessment
//
//  Created by kpc02007-macb3 on 3/21/25.
//

import Foundation
import Combine
import Alamofire

class CountriesViewModel: ObservableObject {
    
    private var countriesData: [CountriesModel] = []

    @Published var countriesList = [String]()
    @Published var uniqueRegions = [String]()
    @Published var filteredCountries = [String]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var errorSubject = PassthroughSubject<CountriesURLError, Never>()
    var errorPublisher: AnyPublisher<CountriesURLError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
//    func getCountries() {
//        let urlEndPoint = "https://restcountries.com/v3.1/all"
//        
//        guard let url = URL(string: urlEndPoint) else {
//            errorSubject.send(.InvalidURL)
//            return
//        }
//        
//        URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { result -> [CountriesModel] in
//                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
//                    throw CountriesURLError.InvalidResponse
//                }
//                let decoder = JSONDecoder()
////                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                return try decoder.decode([CountriesModel].self, from: result.data)
//            }
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                if case .failure(_) = completion {
//                    self?.errorSubject.send(CountriesURLError.InvalidData)
//                }
//            }, receiveValue: { [weak self] countries in
//                self?.countriesData = countries
//                self?.countriesList = countries.map { $0.name.common }.sorted()
//                self?.uniqueRegions = Array(Set(countries.compactMap { $0.region })).sorted()
//            })
//            .store(in: &cancellables)
//    }

    func fetchCountries(){
        let urlEndPoint = "https://restcountries.com/v3.1/all"
        
        guard let url = URL(string: urlEndPoint) else {
            errorSubject.send(.InvalidURL)
            return
        }

        AF.request(url).responseDecodable(of: [CountriesModel].self) { [weak self] response in
            guard let self = self else { return }
            
            switch response.result {
                case .success(let data):
                    countriesData = data
                    countriesList = countriesData.map{ $0.name.common}.sorted()
                    uniqueRegions = Array(Set(countriesData.compactMap { $0.region}))
                    print("Decoded Data: \(data)")
                case .failure (_):
                    errorSubject.send(CountriesURLError.InvalidData)
            }
        }
    }
    
    // MARK: - Countries Filter
    func filterCountries(by region: String){
        filteredCountries = countriesData
            .filter { $0.region == region}
            .map { $0.name.common }
            .sorted()
    }
    
    // MARK: - Validations
    func isValidName(_ name: String) -> Bool {
        let regex = ".*[^A-Za-z].*"
        return !name.isEmpty && !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: name)
    }
    
    func isValidRegion(_ region: String) -> Bool {
        return uniqueRegions.contains(region)
    }
    
    func isValidCountry(_ country: String) -> Bool {
        return filteredCountries.contains(country)
    }
}

enum CountriesURLError: Error {
    case InvalidURL
    case InvalidResponse
    case InvalidData
}
