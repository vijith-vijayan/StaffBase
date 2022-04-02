//
//  Webservice.swift
//  LuluHyperMarket
//
//  Created by Vijith TV on 05/02/22.
//

import Foundation
import Combine


//MARK: - NETWORK LAYER PROTOCOL
protocol NetworkControllerProtocol: AnyObject {
    
    //MARK: - HEADER
    typealias Headers = [String: Any]
    
    //MARK: - GET METHOD
    func get<T>(type: T.Type,
                url: URL
    ) -> AnyPublisher<T, Error> where T: Decodable
}


final class NetworkController: NetworkControllerProtocol {
    
    //MARK: - GET DATA FROM URL
    func get<T>(type: T.Type,
                url: URL) -> AnyPublisher<T, Error> where T : Decodable {
        var request = URLRequest(url: url)
        request.httpMethod = .GET
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    //MARK: - JSON DECODER
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = DBHelper.context
        return decoder
    }
}

//MARK: - EMPLOYEECONTROLLER PROTOCOL
protocol EmployeeControllerProtocol: AnyObject {
    
    var networkController: NetworkControllerProtocol{ get }
    func getEmployees() -> AnyPublisher<[Employee], Error>
}

//MARK: - EMPLOYEE CONTROLLER
final class EmployeeController: EmployeeControllerProtocol {
    
    //MARK: - PROPERTIES
    let networkController: NetworkControllerProtocol
    
    //MARK: - INITIALISER
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }
    
    //MARK: - GET EMPLOYEE DATA FROM REMOTE SERVER
    func getEmployees() -> AnyPublisher<[Employee], Error> {
        let endpoint = Endpoint.employeesData
        return networkController.get(type: [Employee].self, url: endpoint.url)
    }
    
}

//MARK: - ENDPOINTS
//REUSEABLE BASE ENDPOINT STRUCT
struct Endpoint {
    
    var version: String = Constants.version
    var apiKey: String
    var queryItems: [URLQueryItem] = []
}

//MARK: - API SPECIFIC ENDPOINT EXTENSION
extension Endpoint {
    
    //MARK: - URL
    var url: URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = "\(version)\(apiKey)"
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
}

extension Endpoint {
    
    //MARK: - EMPLOYEES DATA DATA
    static var employeesData: Self {
        return Endpoint(apiKey: Constants.apiKey)
    }
    
}
