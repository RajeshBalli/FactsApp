//
//  FactsListViewCell.swift
//  FactsApp
//
//  Created by cts on 21/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

import UIKit
import SnapKit

enum FactsListViewCellConstants {

    // Constants to setup constraints between subviews
    static let constraintTitleLabelTopOffset = 10
    static let constraintLeftOffset = 20
    static let constraintRightOffset = -20
    static let constraintFactsImageViewBottomOffset = -10
}

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
        label.numberOfLines = 0  // support multiple lines
        return label
    }()

    lazy var factsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()

    var imageViewWidthConstraints: Constraint?  // store facts image view width constraint to dynamically change width of the imageview

    // MARK: Methods
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
            make.top.equalTo(self).offset(FactsListViewCellConstants.constraintTitleLabelTopOffset)
            make.left.equalTo(self).offset(FactsListViewCellConstants.constraintLeftOffset)
            make.right.equalTo(self).offset(FactsListViewCellConstants.constraintRightOffset)
        }

        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.left.equalTo(self).offset(FactsListViewCellConstants.constraintLeftOffset)
            make.right.equalTo(self).offset(FactsListViewCellConstants.constraintRightOffset)
        }

        factsImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(1)
            make.left.equalTo(self).offset(FactsListViewCellConstants.constraintLeftOffset)
            make.bottom.equalTo(self).offset(FactsListViewCellConstants.constraintFactsImageViewBottomOffset)
            imageViewWidthConstraints = make.width.equalTo(0).constraint  // set the width as default 0 to resize it dynamically
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let imageSize = factsImageView.image?.size {

            var imageWidth = imageSize.width
            // offsetwidth = spacing at left + spacing at right
            let offsetWidth = CGFloat(FactsListViewCellConstants.constraintLeftOffset - FactsListViewCellConstants.constraintRightOffset)

            // if image extends beyond the cell then resize the image
            if imageSize.width > (bounds.width - offsetWidth) {

                // get new image size based on aspect ratio of image. aspectRatio = (oldWidth / oldHeight). newWidth = (newHeight * aspectRatio).
                imageWidth = factsImageView.bounds.height * ((bounds.width - offsetWidth) / imageSize.height)
            }

            // update imageview width
            imageViewWidthConstraints?.update(offset: imageWidth)
        }
    }
}
