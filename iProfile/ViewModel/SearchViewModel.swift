//
//  SearchViewModel.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import UIKit

class SearchViewModel
{
    var dataArray = NSMutableArray()
    var refinedArray = NSMutableArray()
    
    
    //use this for Select data
    func readAllData(completion: @escaping (Result<Bool, Error>) -> Void)
    {
        SqliteHelper.sharedInstance.SelectData(Tblname:  TBL_EMP, ColumnNames: [], SelectALL: true)
         { (status, MSG,  dic_result) in
            print(MSG)
            print(dic_result)
            self.dataArray = dic_result
            self.refinedArray = dic_result
            completion(.success(true))
        }
    }
    
    func searchEmployee(with searchText: String, completion: @escaping () -> Void)
    {
        if !searchText.isEmpty
        {
            self.refinedArray = NSMutableArray(array:dataArray.filter({ ($0 as! Employee).employee_name.contains(searchText)}))
        } else
        {
           self.refinedArray = self.dataArray
        }
    
        completion()
    }
    
}
