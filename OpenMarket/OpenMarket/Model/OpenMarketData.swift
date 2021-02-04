//
//  OpenMarketData.swift
//  OpenMarket
//
//  Created by 임리나 on 2021/01/30.
//

import UIKit

class OpenMarketData {
    static let shared = OpenMarketData()
    var productList: [Product] = []
    var currentPage: Int = 1
    var isPaging = false
    var hasPage = true
    var lastItemCount = 0
    var cacheImages = NSCache<NSURL, UIImage>()
    
    
    private init() { }
    
    func loadImage(imageURL: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(.failure(OpenMarketError.wrongURL))
            return
        }
        if let image = cacheImages.object(forKey: url as NSURL) {
            completion(.success(image))
            return
        }
        let urlRequest = URLRequest(url: url)
        NetworkHandler().startLoad(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.cacheImages.setObject(image, forKey: url as NSURL)
                    completion(.success(image))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}
