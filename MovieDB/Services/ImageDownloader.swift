//
//  ImageDownloader.swift
//  MovieDB
//
//  Created by Summit on 20/12/20.
//

import UIKit

class ImageDownloader: Operation {
    var imageUrl: String
    var indexPath: IndexPath
    var didFinished: ((_ indexPath: IndexPath, _ image: UIImage?)-> Void)?
    
    init(_ movie: Movie, indexPath: IndexPath, _ finishClosure: @escaping (_ indexPath: IndexPath, _ image: UIImage?)-> Void ) {
        imageUrl = movie.posterUrl
        self.indexPath = indexPath
        didFinished = finishClosure
    }
    
    override func main() {
        if isCancelled {
            return
        }
        do {
            let imagePath = ApiCallManager.imagePath(endpath: imageUrl, type: .poster)
            let data = try Data(contentsOf: imagePath)
            if isCancelled {
                return
            }
            let image = UIImage(data: data)
            didFinished?(indexPath, image)
        }catch {
            print(error.localizedDescription)
        }
    }
}
