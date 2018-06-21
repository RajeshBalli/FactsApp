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
    var imageCache: [String: FactsRowData] = [:]

    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.showsHorizontalScrollIndicator = true
        tableView.register(FactsListViewCell.self, forCellReuseIdentifier: factsTableViewCellUniqueID)

        serviceManager.fetchFacts() { [weak self] in

            self?.navigationItem.title = self?.serviceManager.factsTitle
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

            if let cachedFactsData = imageCache[imageURL_] {

                cell.factsImageView.image = cachedFactsData.image
            } else {

                serviceManager.fetchFactsImage(factsRowData: factsData) { [weak self] in

                    self?.imageCache[imageURL_] = factsData

                    if let updateCell = self?.tableView?.cellForRow(at: indexPath) as? FactsListViewCell, updateCell.factsImageView.image == nil {

                        updateCell.factsImageView.image = factsData.image
                        updateCell.setNeedsLayout()
                    }
                }
            }
        }

        return cell
    }
}

