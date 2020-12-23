//
//  DataSource.swift
//  MovieDB
//
//  Created by Summit on 19/12/20.
//

import UIKit

class DataSource {
    var totalPage: Int = 0
    var currentPage: Int = 0
    
    private var oprationQueue: OperationQueue = {
       let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 10
        return operation
    }()
    
    private var pendingOperations: [IndexPath: Operation] = [:]
    
    init() {
        getFirstPageMovieList()
    }
    
    var movieList: [Movie] {
        get {
            if isSearching {
                return searchList
            }else {
                return _movieList
            }
        }
        set {
            if isSearching {
                searchList = newValue
            }else {
                _movieList = newValue
            }
        }
    }
    
    var _movieList: [Movie] = []
    
    var searchList: [Movie] = []
    
    var isSearching: Bool = false
    
    //private var backUPList
    
    var didUpdateValue: ((_ for: UpdateDataType) -> ())?
    
    func cancelOperation(at indexPath: IndexPath) {
        pendingOperations[indexPath]?.cancel()
    }
    
    func sortMovielist(by type: SortType) {
        switch type {
        case .mostPopular:
            movieList = movieList.sorted(by: {
                $0.popularity > $1.popularity
            })
        case .topRated:
            movieList = movieList.sorted(by: {
                $0.rating > $1.rating
            })
        }
        didUpdateValue?(.newData)
    }
    
    enum SortType {
        case mostPopular, topRated
    }
    
    
    // MARK:- Fetch movielist data.
    func getFirstPageMovieList() {
        getMovieList(at: 1)
    }
    
    func getNextPageMovieList() {
        if currentPage < totalPage {
            getMovieList(at: currentPage + 1)
        }
        
    }
    
    func getMovieList(at Page: Int) {
        ApiCallManager.getMovieList(Page) { [weak self] (dataModel) in
            guard let strongSelf = self else { return }
            if let data = dataModel {
                if strongSelf.movieList.isEmpty {
                    strongSelf.movieList = data.movieList
                }else {
                    strongSelf.movieList.append(contentsOf: data.movieList)
                }
                strongSelf.currentPage = data.page
                strongSelf.totalPage = data.totalPages
                strongSelf.didUpdateValue?(.newData)
            }
        }
    }
    
    func getSearchMovieList(for searchKey: String) {
        ApiCallManager.getSearchResultList(searchKey) { [weak self] (dataModel) in
            if let data = dataModel {
                self?.searchList = data.movieList
                self?.didUpdateValue?(.newData)
            }
        }
    }
    
    // MARK:- Download PosterImage.
    func downloadPosterImage(indexPath: IndexPath) {
        if let _ = pendingOperations[indexPath] {
            return
        }
        
        let imageDownload = ImageDownloader(movieList[indexPath.row], indexPath: indexPath, onDownloadFinished(_:_:))
        oprationQueue.addOperation(imageDownload)
        pendingOperations[indexPath] = imageDownload
    }
    
    private func onDownloadFinished(_ indexPath: IndexPath, _ image: UIImage?) {
        movieList[indexPath.row].posterImage = image
        
        if pendingOperations.keys.contains(indexPath) {
            pendingOperations.removeValue(forKey: indexPath)
        }
        didUpdateValue?(.imageData(indexPath))
    }
}

enum UpdateDataType {
    case newData, imageData(IndexPath)
}
