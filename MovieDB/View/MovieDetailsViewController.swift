//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Summit on 20/12/20.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // Outlets
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var movieDetails: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupOutlets()
    }
    
    private func setupOutlets() {
        movieTitle.text = movieDetails.title
        thumbnail.image = movieDetails.posterImage
        rating.text = "\(movieDetails.rating)"
        overview.text = movieDetails.overview
        subHeading.text = subHeadingText()
    }
    
    func subHeadingText() -> String {
        let genreString = Configuraition.genreNames(of: movieDetails.genres)
        return "\(movieDetails.releaseDate) (\(movieDetails.language.uppercased())) \n\(genreString)"
    }
    

}
