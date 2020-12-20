//
//  ViewController.swift
//  MovieDB
//
//  Created by Summit on 19/12/20.
//

import UIKit
import Combine

class MovieListController: UIViewController {
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingButton: UIBarButtonItem!
    
    // Properties
    let dataSource = DataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Tableview Cell
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "moviecell")
        dataSource.didUpdateValue = reloadTableData
        sortingButton.menu = UIMenu(title: "", children: [
            UIAction(title: "Most popular", image: nil, handler: { _ in
                self.dataSource.sortMovielist(by: .mostPopular)
            }),
            UIAction(title: "Best rated", handler: { _ in
                self.dataSource.sortMovielist(by: .topRated)
            })
        ])
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetails = sender as? Movie else {
            return
        }
        (segue.destination as? MovieDetailsViewController)?.movieDetails = movieDetails
    }
    
    func reloadTableData(for dataType: UpdateDataType) {
        DispatchQueue.main.async {
            switch dataType {
            case .imageData(let indexPath):
                guard let visibleIndices = self.tableView.indexPathsForVisibleRows else { return }
                if visibleIndices.contains(indexPath) {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            case .newData:
                self.tableView.reloadData()
            }
        }
        
    }


}

extension MovieListController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.movieList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        500
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataSource.movieList.count - 3 {
            dataSource.getNextPageMovieList()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "moviecell", for: indexPath) as! MovieCell
        let movieData = dataSource.movieList[indexPath.row]
        movieCell.movieTitle.text = movieData.title
        if let posterImage = movieData.posterImage {
            //activityIndicator.stopAnimation
            movieCell.moviePosterView.image = posterImage
        }else {
            movieCell.moviePosterView.image = nil
            dataSource.downloadPosterImage(indexPath: indexPath)
        }
    
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource.movieList[indexPath.row]
        self.performSegue(withIdentifier: "detailsviewsegue", sender: data)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let movieData = dataSource.movieList[indexPath.row]
            if movieData.posterImage == nil {
                dataSource.downloadPosterImage(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            dataSource.cancelOperation(at: indexPath)
        }
    }
}

extension MovieListController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        dataSource.isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            dataSource.isSearching = false
            reloadTableData(for: .newData)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSource.getSearchMovieList(for: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
}
