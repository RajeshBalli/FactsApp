//
//  ServiceManager.swift
//  FactsApp
//
//  Created by cts on 21/06/18.
//  Copyright © 2018 CTS. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum FactsServiceConstants {

    static let factsURLPath = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}

class FactsRowData {

    // MARK: Properties
    var title: String?
    var description: String?
    var imageURL: String?
    var image: UIImage?

    // MARK: Methods
    required init(aTitle: String?, aDescription: String?, anImageURL: String?) {

        title = aTitle
        description = aDescription
        imageURL = anImageURL
    }
}

class ServiceManager {

    // MARK: Properties
    var factsTitle = ""
    var factsRowData = [FactsRowData]()

    // MARK: Methods
    func fetchFacts(completionHandler: @escaping () -> Void) {

        Alamofire.request(FactsServiceConstants.factsURLPath)
            .response { [weak self] response in
                guard let factsJsonRawData = response.data else {
                    print("Could not get data from URL.")
                    return
                }

                let factsJsonStr = NSString(data: factsJsonRawData, encoding: String.Encoding.isoLatin1.rawValue)

                if let factsJsonData = factsJsonStr?.data(using: String.Encoding.utf8.rawValue) {

                    do {

                        let factsJson = try JSON(data: factsJsonData)

                        self?.factsTitle = factsJson["title"].stringValue

                        let count = factsJson["rows"].count

                        for index in 0..<count
                        {
                            if factsJson["rows"][index]["title"] != JSON.null
                                || factsJson["rows"][index]["description"] != JSON.null
                                || factsJson["rows"][index]["imageHref"] != JSON.null
                            {
                                let factsRowData = FactsRowData(aTitle: factsJson["rows"][index]["title"].stringValue,
                                                                aDescription: factsJson["rows"][index]["description"].stringValue,
                                                                anImageURL: factsJson["rows"][index]["imageHref"].stringValue)

                                self?.factsRowData.append(factsRowData)
                            }
                        }
                    } catch let error as NSError {

                        print("SwiftyJSON Data error: \(error)")
                    }
                }

                completionHandler()
        }
    }
}
