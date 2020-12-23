//
//  ApicallManager.swift
//  MovieDB
//
//  Created by Summit on 19/12/20.
//

import Foundation
import Combine

class ApiCallManager {
    static let _manager = ApiCallManager()
    private init() { }
    
    static func configure() {
        
        DispatchQueue.global().sync {
            _manager.configure()
            _manager.getGenreList() { genres in
                Configuraition.genres = genres
            }
        }
    }
    
    
    
    private let apiKey: String = "e5b740bf3465913cda37cdc690cf95e0"
    
    private let movieUrl: String = "https://api.themoviedb.org/3/movie/now_playing"
    
    private var imageBaseUrl: String?
    
    private var supportedLogoSizes: [String] = []
    
    private var supportedPosterSizes: [String] = []
    
    private var cancelables = Set<AnyCancellable>()
    
    static func getMovieList(_ page: Int, completion: @escaping (_ requestModel: RequestModel?) -> Void) {
        _manager.getMovieList(at: page) { (requestModel) in
            completion(requestModel)
        }
    }
    
    static func getSearchResultList(_ searchKey: String, completion: @escaping (_ requestModel: RequestModel?) -> Void) {
        _manager.getSearchResult(with: searchKey) { (requestModel) in
            completion(requestModel)
        }
    }
    
    static func imagePath(endpath: String, type: ImageType) -> URL {
        guard let baseUrl = _manager.imageBaseUrl, var url = URL(string: baseUrl) else {
             fatalError("imagebaseURL is found as nil")
        }
        let imageSize = type == .poster ? _manager.supportedPosterSizes.contains("w342") ? "w342" : _manager.supportedPosterSizes[0] : _manager.supportedLogoSizes.contains("w154") ? "w154" : _manager.supportedLogoSizes[0]
        url.appendPathComponent(imageSize)
        url.appendPathComponent(endpath)
        return url
    }
    
    enum ImageType {
        case poster, thumbnail
    }
    
    func configure() {
        var urlComponent = URLComponents(string: "https://api.themoviedb.org/3/configuration")!
        urlComponent.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let rawData = try? Data(contentsOf: urlComponent.url!) else {
            fatalError("Image source must required to download image")
        }
        do {
            let configData = try JSONDecoder().decode(Configuraition.self, from: rawData)
            supportedLogoSizes = configData.imageConfig.thumbnailSizes
            supportedPosterSizes = configData.imageConfig.posterSizes
            imageBaseUrl = configData.imageConfig.imagesBaseUrl
        }catch { print(error.localizedDescription) }
        
        
        
//        URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
//            .tryMap { (data, response) -> Data in
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw URLError(.badServerResponse) }
//                return data
//            }
//            .decode(type: Configuraition.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { print("complete with \($0)"); onFinish() }, receiveValue: { [weak self] config in
//                self?.supportedLogoSizes = config.imageConfig.thumbnailSizes
//                self?.supportedPosterSizes = config.imageConfig.posterSizes
//                self?.imageBaseUrl = config.imageConfig.imagesBaseUrl
//                onFinish()
//            })
//            .store(in: &cancelables)
        
    }
    
    func getMovieList(at page: Int, completion: @escaping (_ listModel: RequestModel?) -> Void) {
        var urlComponent = URLComponents(string: movieUrl)!
        urlComponent.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                               URLQueryItem(name: "page", value: "\(page)") ]
        URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw URLError(.badServerResponse) }
                return data
            }
            .decode(type: RequestModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {print("Completion with value \($0)") }) { (listmodel) in
                completion(listmodel)
            }
            .store(in: &cancelables)
    }
    
    func getGenreList(_ completion: (_ genre: [MovieGenre]) -> Void) {
        var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/genre/movie/list")!
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let rawData = try? Data(contentsOf: urlComponents.url!) else { return }
        do {
            let genresList = try JSONDecoder().decode([String: [MovieGenre]].self, from: rawData)
            completion(genresList["genres"]!)
        }catch { print(error.localizedDescription) }
        
//        URLSession.shared.dataTaskPublisher(for: urlComponents.url!)
//            .tryMap { (data, response) -> Data in
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw URLError(.badServerResponse) }
//                return data
//            }
//            .decode(type: [String: [MovieGenre]].self, decoder: JSONDecoder())
//            .sink( receiveCompletion: {
//                print("completion value \($0)")
//            }, receiveValue: { genrelist in
//                if let genres = genrelist["genres"] {
//                    completion(genres)
//                }
//            })
//            .store(in: &cancelables)
        
    }
    
    func getSearchResult(with searchKey: String, completion: @escaping (_ listModel: RequestModel?) -> Void) {
        var urlComponent = URLComponents(string: "https://api.themoviedb.org/3/search/movie")!
        urlComponent.queryItems = [ URLQueryItem(name: "api_key", value: apiKey),
                                    URLQueryItem(name: "query", value: searchKey)]
        URLSession.shared.dataTaskPublisher(for: urlComponent.url!)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw URLError(.badServerResponse) }
                return data
            }
            .decode(type: RequestModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {print("Completion with value \($0)") }) { (listmodel) in
                completion(listmodel)
            }
            .store(in: &cancelables)
        
        
    }
    
}

