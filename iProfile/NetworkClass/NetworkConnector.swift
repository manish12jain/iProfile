//
//  NetworkConnector.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import UIKit

struct NetworkConnector
{
    static let sharedInstance = NetworkConnector()
    
    /// This method is to get Employees
    func getEmployeeAPIData(completion: @escaping (Result<[Employee], Error>) -> Void) {
        let urlString = Constants.getEmployeeURL
        getRequest(requestUrl: URL(string: urlString)!, resultType: Employee.self) { result in
            switch(result) {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
     private func getRequest<Employee: Decodable>(requestUrl: URL, resultType: Employee.Type, completion: @escaping (Result<[Employee], Error>) -> Void) {
         URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
             if let err = error {
                 completion(.failure(err))
                 print(err.localizedDescription)
             } else {
                 guard let data = data else { return }
                 let jsonString = String(decoding: data, as: UTF8.self)
                 do {
                     let results = try JSONDecoder().decode([Employee].self, from: jsonString.data(using: .utf8)!)
                     completion(.success(results))
                 } catch {
                     print(error)
                     completion(.failure(error))
                 }
             }
             }.resume()
     }
}
