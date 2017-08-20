//
//  FromAPIProductRepository.swift
//  ProductsView
//
//  Created by mac on 8/19/17.
//  Copyright © 2017 experiments. All rights reserved.
//

import UIKit

class FromAPIProductRepository: BaseProductRepository {
    private static let baseUrl = "http://grapesnberries.getsandbox.com/products"
    
    private static let urlSessionConfig = URLSessionConfiguration.default
    
    static func urlEncode(string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
    
    static func urlEncodeParameters(_ parameters: [String: Any?]) -> String {
        var ret = ""
        for (key, value) in parameters {
            if ret != "" { ret.append("&") }
            ret.append(urlEncode(string: key))
            ret.append("=")
            ret.append(urlEncode(string: String(describing: value ?? "null")))
        }
        return ret
    }
    
    /// Prepares the URL Request to call to get data. Can be overridden when the API changes
    ///
    /// - Parameter range: Range of product entities ID's to get (may be just one ID)
    /// - Returns: The `URLRequest` ready to be passed to `URLSession` functions
    func prepareURLRequest(for range: Range<Int>) -> URLRequest {
        let parameters = FromAPIProductRepository.urlEncodeParameters([
            "from": range.lowerBound,
            "count": range.count
            ])
        let fullUrl = FromAPIProductRepository.baseUrl + "?" + parameters
        let urlRequest = URLRequest(url: URL(string: fullUrl)!)
        
        return urlRequest
    }
    
    /// Calls URL session, prepares it first using `prepareURLRequest(for:)`, then
    ///    calls the session, when completion, calls the specified closure, with the JSON as the
    ///    first parameters, and the error is the second one.
    ///
    /// - Parameters:
    ///   - range: Range of IDs to get
    ///   - completion: The function to be called when API returns
    func callSession(with range: Range<Int>, completion: @escaping (Any?, Error?) -> ()) {
        URLSession(configuration: FromAPIProductRepository.urlSessionConfig)
            .dataTask(with: prepareURLRequest(for: range), completionHandler: {data, _, error in
                if let err = error {
                    completion(nil, err)
                } else {
                    guard let json = try? JSONSerialization.jsonObject(with: data ?? Data()
                        , options: .init(rawValue: 0)) else { completion(nil, nil); return }
                    completion(json, nil)
                }
            }).resume()
    }
    
    override func object(by id: Int, completion: @escaping (ProductEntity?, Error?) -> ()) {
        callSession(with: id..<id, completion: {json, error in
            guard let first = (json as? NSArray ?? []).firstObject else { completion(nil, error); return }
            completion(ProductSerialization.product(from: first), nil)
        })
    }
    
    override func objects(for range: Range<Int>, completion: @escaping ([ProductEntity]?, Error?) -> ()) {
        callSession(with: range, completion: {json, error in
            guard let array = json as? NSArray else { completion(nil, error); return }
            var ret : [ProductEntity] = []
            for i in array {
                ret.append(ProductSerialization.product(from: i))
            }
            completion(ret, nil)
        })
    }
}
