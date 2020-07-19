//
//  Constant.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import Foundation

//MARK: - ENUMS


enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case deleta = "DELETE"
}

//MARK: - CONSTANTS

struct Constants {
    
    static let getEmployeeURL  =  "https://demo6481599.mockable.io/profiles"

    static let errorTitle = "Error"
    static let ok = "OK"
    static let applicationJson = "application/json"
    static let contentType = "Content-Type"
    static let success = "success"
    static let nameRegularExpression = ".*[^A-Za-z ].*"
    static let employeeCell = "EmployeeCell"
    static let searchBarIndentifier = "SearchBar"
    static let employeeTableViewIndentifier = "EmployeeTableView"
    static let submitSuccessMessage = "Employee record added successfully."
    static let employeeNameError = "Please enter Name."
    static let employeeNameInValidError = "Please enter valid Name."
    static let employeeAgeEmptyError = "Please enter Age."
    static let employeeAgeError = "Please enter valid Age."
    static let employeeSalaryEmptyError = "Please enter Salary."
    static let employeeSalaryError = "Please enter valid Salary."
    static let nameTextFieldIndentifier = "NameTextField"
    static let ageTextFieldIndentifier = "AgeTextField"
    static let salaryTextFieldIndentifier = "SalaryTextField"
    static let profileLoadText = "Load Profiles"
    static let profileLoadedText = "Profiles Loaded"
    static let profileDeletedText = "Profiles Deleted"
    static let emplNameText = "Employee Name : "

}
