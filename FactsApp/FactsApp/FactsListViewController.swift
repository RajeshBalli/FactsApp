//
//  FactsListViewController.swift
//  FactsApp
//
//  Created by cts on 21/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

import UIKit

class FactsListViewController: UITableViewController {

    // MARK: Properties
    private let serviceManager = ServiceManager()
    private let factsTableViewCellUniqueID = "factsTableViewCell"
    var imageCache: [String: FactsRowData] = [:]  // used for image caching
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let refreshDataControl: UIRefreshControl = UIRefreshControl()

    
    // MARK: Methods
    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.register(FactsListViewCell.self, forCellReuseIdentifier: factsTableViewCellUniqueID)

        refreshDataControl.addTarget(self, action: #selector(FactsListViewController.refreshData), for: .valueChanged)
        refreshControl = refreshDataControl

        activityIndicator.center = view.center
        activityIndicator.color = .gray

        view.addSubview(activityIndicator)

        fetchFactsData()
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchFactsData(endRefreshing: Bool = false) {

        activityIndicator.startAnimating()

        // Fetch facts json, parse data and cache it in memory
        serviceManager.fetchFacts() { [weak self] in
            
            self?.navigationItem.title = self?.serviceManager.factsTitle
            self?.tableView.reloadData()
            
            self?.activityIndicator.stopAnimating()

            // End table view refresh only during refresh data flow
            if endRefreshing == true {

                self?.refreshControl?.endRefreshing()
            }
        }
    }

    @objc func refreshData() {

        refreshControl?.beginRefreshing()
        serviceManager.resetFactsData()  // Reset cached data
        fetchFactsData(endRefreshing: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

      super.viewWillTransition(to: size, with: coordinator)

      // reload during orientation change as images are not refreshing
      self.tableView.reloadData()
    }

    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return serviceManager.factsRowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: factsTableViewCellUniqueID, for: indexPath) as! FactsListViewCell

        cell.selectionStyle = .none

        let factsData = serviceManager.factsRowData[indexPath.row]

        cell.titleLabel.text = factsData.title
        cell.descriptionLabel.text = factsData.description

        cell.factsImageView.image = nil

        if let imageURL_ = factsData.imageURL {

            if let cachedFactsData = imageCache[imageURL_] {  // is image cached? if cached then do not download else download and cache it

                cell.factsImageView.image = cachedFactsData.image
            } else {

                serviceManager.fetchFactsImage(factsRowData: factsData) { [weak self] in   // download image on demand

                    self?.imageCache[imageURL_] = factsData  // cache downloaded image

                    if let updateCell = self?.tableView?.cellForRow(at: indexPath) as? FactsListViewCell, updateCell.factsImageView.image == nil {   // if cell is visible and image is not set then update the image

                        updateCell.factsImageView.image = factsData.image
                        tableView.reloadRows(at: [indexPath], with: .automatic)  // SetNeedsLayout and LayoutIfNeeded are not refreshing the cell so reloading the specific row at that particular index
                    }
                }
            }
        }

        return cell
    }
}

