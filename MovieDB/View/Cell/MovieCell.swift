//
//  MovieCell.swift
//  MovieDB
//
//  Created by Summit on 19/12/20.
//

import UIKit

class MovieCell: UITableViewCell {
    // Outlets
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupOutlets()
        
    }
    
    private func setupOutlets() {
        moviePosterView.layer.cornerRadius = 10
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
