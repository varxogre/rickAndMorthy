//
//  ViewController.swift
//  RickAndMorty
//
//  Created by сергей on 14.01.2021.
//

import UIKit

class CharactersViewController: UIViewController {
    
    private let characterManager = Character()
    private var characters: [CharacterModel] = []
    private var currentPage = 1
    private var maxPage = 0
    private var totalCount = 0
    private var isFetchInProgress = false
    lazy var tableView = UITableView()
    lazy var indicatorView = UIActivityIndicatorView()
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createIndicatorView()
        indicatorView.color = UIColor(red: CGFloat(0), green: CGFloat(104/255.0), blue: CGFloat(55/255.0), alpha: CGFloat(1.0))
        indicatorView.startAnimating()
        createTableView()
        fetchInfo()
        fetchCharacters()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func createIndicatorView()  {
        indicatorView = UIActivityIndicatorView(style: .large)
        let constX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        let constY = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0);
        view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([constX, constY])
    }
    
    private func createTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.backgroundColor = .gray
        tableView.isHidden = true
        view.addSubview(tableView)
    }
    
    private func fetchInfo() {
        characterManager.getInfo(completion: {
            switch $0 {
            case .success(let response):
                self.maxPage = response.info.pages
                self.totalCount = response.info.count
                print(self.totalCount)
            case.failure(let error):
                print(error)
            }
        })
    }
    
    private func fetchCharacters() {
        
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        characterManager.getCharactersByPageNumber(pageNumber: currentPage) { result in
            switch result {
            case.failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.onFetchFailed(with: error.localizedDescription)
                    print(error)
                }
            case .success(let characters):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.characters.append(contentsOf: characters)
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: characters)
                        self.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.onFetchCompleted(with: nil)
                    }
                    self.currentPage += 1
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newCharacters: [CharacterModel]) -> [IndexPath] {
        let startIndex = characters.count - newCharacters.count
        print(startIndex)
        let endIndex = startIndex + newCharacters.count
        print(endIndex)
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}

extension CharactersViewController {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        //      let title = "Warning"
        //      let action = UIAlertAction(title: "OK", style: .default)
        //      displayAlert(with: title , message: reason, actions: [action])
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= characters.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension CharactersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterCell
        
        if isLoadingCell(for: indexPath) {
            cell.backgroundColor = .darkGray
            cell.nameLabel.text = "Loading information"
        } else {
            cell.backgroundColor = .darkGray
            cell.nameLabel.text = characters[indexPath.row].name
            cell.locationLabel.text = characters[indexPath.row].location.name
            cell.statusLabel.text = characters[indexPath.row].status + " - " + characters[indexPath.row].species
            cell.mainImage.loadImageUsingCache(withUrl: characters[indexPath.row].image)
        }
        return cell
    }
    
}

extension CharactersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
}

extension CharactersViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fetchCharacters()
        }
    }
    
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil { return }
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self?.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}

