//
//  FactsListViewCell.swift
//  FactsApp
//
//  Created by cts on 21/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

import UIKit
import SnapKit

class FactsListViewCell: UITableViewCell {

    // MARK: Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    lazy var factsImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    // Requierd for custom cell class to compile
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(factsImageView)

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        factsImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(1)
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-10)
        }
    }
}
