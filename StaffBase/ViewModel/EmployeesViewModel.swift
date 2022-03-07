//
//  EmployeesViewModel.swift
//  StaffBase
//
//  Created by Vijith TV on 05/03/22.
//

import Foundation
import Combine
import CoreData

class EmployeesViewModel {
    
    //MARK: - PROPERTIES
    private let networkController = NetworkController()
    private lazy var employeeController = EmployeeController(networkController: networkController)
    private var subscription = Set<AnyCancellable>()

    
    /* DBMANAGER */
    let dbmanager = DBManager<Employee>()
    
    /* ARRAY */
    var employees: [Employee]?
    
    //MARK: -  GET EMPLOYEES

    func getEmployees(callback: @escaping () -> ()) {
        employeeController.getEmployees()
            .sink { (completion) in
                switch completion {
                case let .failure(error):
                    print("Couldn't get data: \(error)")
                case .finished: break
                }
            } receiveValue: { [weak self](employeeModel) in
                guard let weakself = self else { preconditionFailure("Home VM init failed") }
                weakself.saveEmployeesToDB(employees: employeeModel)
                callback()
            }.store(in: &subscription)
    }
    
    //MARK: - SAVE EMPLOYEES
    private func saveEmployeesToDB(employees: [Employee]) {
        employees.forEach { employee in
            dbmanager.store { dbModel in
                dbModel.id = employee.id
                dbModel.name = employee.name
                dbModel.phone = employee.phone
                dbModel.email = employee.email
                dbModel.profileImage = employee.profileImage
                dbModel.username = employee.username
                dbModel.website = employee.website
                dbModel.company = employee.company
                dbModel.address = employee.address
            }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("an error occurred \(error.localizedDescription)")
                case .finished:
                    debugPrint("PRINT VALUE \(completion)")
                }
            } receiveValue: { employee in
                debugPrint("EMPLOYEE SAVED")
            }.store(in: &subscription)
        }
    }
    
    //MARK: - GET EMPLOYEES FROM DB

    func getEmployeesFromDB(predicate: NSPredicate? = nil, callback: @escaping ([Employee]) -> () ) {
        dbmanager.fetch(predicate: predicate)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("an error occurred \(error.localizedDescription)")
                case .finished:
                    debugPrint("PRINT VALUE \(completion)")
                }
            } receiveValue: { employee in
                if predicate == nil { self.employees = employee }
                callback(employee)
        }.store(in: &subscription)
    }
}
