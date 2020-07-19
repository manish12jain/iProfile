//
//  HomeViewModel.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import Foundation

class HomeViewModel
{

    var dataArray = [Employee]()

    
    func getEmployeeData(completion: @escaping (Result<Bool, Error>) -> (Void))
    {
        let data : String = "8298"
        print(data.toBase64())
        
        NetworkConnector.sharedInstance.getEmployeeAPIData { (result) in
            DispatchQueue.main.async
            {
                switch(result)
                {
                    case .success(let result):
                        self.saveToDB(data: result)
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
    func saveToDB(data:[Employee])
    {
        for employee in data
        {
            SqliteHelper.sharedInstance.InsertData(Tblname: TBL_EMP, Columns: [USER_COLUMNS.empID.rawValue,USER_COLUMNS.employee_age.rawValue,USER_COLUMNS.employee_name.rawValue,USER_COLUMNS.employee_salary.rawValue,USER_COLUMNS.profile_image.rawValue], Values : [employee.id.toBase64(),employee.employee_age.toBase64(),employee.employee_name.toBase64(),employee.employee_salary.toBase64() ,employee.profile_image.toBase64()], DataTypes : [TYPE_TEXT,TYPE_TEXT,TYPE_TEXT,TYPE_TEXT,TYPE_TEXT]) { (status, MSG) in
                if status {
                    print("Sucess \(MSG)")
                }else{
                    print("Failed \(MSG)")
                }
            }
        }
    }
}
