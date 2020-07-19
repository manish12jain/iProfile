//
//  SqliteHelper.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import UIKit
import SQLite3

public let TYPE_INT    = "integer"
public let TYPE_TEXT    = "text"


public let DB_NAME     = "Employee"
public let TBL_EMP     = "TBL_EMP"

internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

public enum ASEND_DESEND_TYPE : String {
    case DESC       = "desc"
    case AESC       = "asc"
}

public enum USER_COLUMNS : String
{
    case empID           = "empID"
    case employee_name   = "employee_name"
    case employee_salary = "employee_salary"
    case employee_age    = "employee_age"
    case profile_image   = "profile_image"
}

class SqliteHelper: NSObject {

    static let sharedInstance = SqliteHelper()
    
    // MARK:  - This class connect Database
    func DBConnect() -> OpaquePointer {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("\(DB_NAME).sqlite")
        
        print(fileURL)

        // open database
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }else{
            print("DB connected")
        }
        return db!
    }
    
    
    // MARK:  - Create tables which is we using on database
    func CreateALLTables() -> Void {
        
        var statementChk: OpaquePointer?
        sqlite3_prepare_v2(DBConnect(), "SELECT * FROM \(TBL_EMP)", -1, &statementChk, nil);
        var boo = false
        if (sqlite3_step(statementChk) == SQLITE_ROW) {
            boo = true
        }
        sqlite3_finalize(statementChk);
        if !boo {
            if sqlite3_exec(DBConnect(), "create table if not exists \(TBL_EMP) (empID text, employee_name text, employee_salary text, employee_age text, profile_image text)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
                print("error creating table: \(errmsg)")
            }else{
                print("\(TBL_EMP) table created")
            }
        }else{
            print("\(TBL_EMP) table Already Exists")
        }
    }
    
    // MARK:  - Insert a data on table
    func InsertData(Tblname: String, Columns : NSArray,  Values : NSArray,  DataTypes : NSArray,  CompletionHandler: (_ Status: Bool ,_ MSG : String) -> ()) -> Void {
        var statement: OpaquePointer?
        
        var str_Values = ""
        for i in 0..<Columns.count {
            DataTypes.object(at: i) as! String != TYPE_INT ? str_Values.append("'\(Values.object(at: i))',") : str_Values.append("\(Values.object(at: i)),")
        }
        str_Values.removeLast()
        
        print("insert into \(Tblname) (\(Columns.componentsJoined(by: ","))) values (\(str_Values))")
        
        if sqlite3_prepare_v2(DBConnect(), "insert into \(Tblname) (\(Columns.componentsJoined(by: ","))) values (\(str_Values))", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
            print("error preparing insert: \(errmsg)")
        }
        if sqlite3_bind_text(statement, 1, "foo", -1, SQLITE_TRANSIENT) != SQLITE_OK { //SQLITE_TRANSIENT
            let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
            print("failure binding foo: \(errmsg)")
            CompletionHandler(false,"failure inserting foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
            print("failure inserting foo: \(errmsg)")
            CompletionHandler(false,"failure inserting foo: \(errmsg)")
        }else{
            print("inserted sucesfully")
            CompletionHandler(true,"inserted sucesfully")
        }
    }
    
    func DeleteData(Tblname: String, CompletionHandler: (_ Status : Bool , _ MSG : String) -> ()) -> Void {
           var statement: OpaquePointer?
           let Del_Query = "Delete from \(Tblname)"
           print(Del_Query)
           
           if sqlite3_prepare_v2(DBConnect(), Del_Query, -1, &statement, nil) != SQLITE_OK {
               let errorMSg = "Delete Query Error \(String(cString: sqlite3_errmsg(DBConnect())))"
               print(errorMSg)
               CompletionHandler(false,errorMSg)
           }
           
           if sqlite3_step(statement) != SQLITE_DONE {
               let errorMSg = "Delete Query Error \(String(cString: sqlite3_errmsg(DBConnect())))"
               print(errorMSg)
               CompletionHandler(false,errorMSg)
           }else{
               CompletionHandler(true,"Delted row sucessfully")
           }
       }

    // MARK:  :- AscendORDescendOrder - 1 = ascending , 2 = descending , 3 = none
       func SelectData(Tblname: String, ColumnNames : NSArray, SelectALL : Bool,  CompletionHandler: (_ Status: Bool ,_ MSG : String , _ Result : NSMutableArray) -> ()) -> Void {
           var statement: OpaquePointer?
           let selectcolumn = SelectALL ? "*" : ColumnNames.componentsJoined(by: ",")
           let selectQry = "select \(selectcolumn) from \(Tblname)"
           print(selectQry)
           
           if sqlite3_prepare_v2(DBConnect(), selectQry, -1, &statement, nil) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
               print("error preparing select: \(errmsg)")
           }
           
           let arrResult = NSMutableArray()
           
           while sqlite3_step(statement) == SQLITE_ROW {
               let dic_row = NSMutableDictionary()
            
               for i in 0..<sqlite3_column_count(statement){
                   var Name = ""
                   var Value = ""
                   if let cString = sqlite3_column_name(statement, i) {
                       Name = String(cString: cString)
                       print("name = \(Name)")
                   }else{
                       print("name not found")
                   }
                   
                   if let cString = sqlite3_column_text(statement, i) {
                       Value = String(cString: cString)
                       print("name = \(Value)")
                   } else {
                       print("Value not found")
                   }
                dic_row .setValue(Value.fromBase64(), forKey: Name)
               }
            
            
            
            let employeObj = Employee(id: dic_row["empID"] as! String, employee_name: dic_row["employee_name"] as! String, employee_salary: dic_row["employee_name"] as! String, employee_age: dic_row["employee_name"] as! String, profile_image: dic_row["employee_name"] as? String ?? "")
                
            arrResult.add(employeObj)
           }
        
           print(arrResult)
        
           if sqlite3_finalize(statement) != SQLITE_OK {
               let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
               print("error finalizing prepared statement: \(errmsg)")
           }
           else
           {
            CompletionHandler(true,"result",arrResult)
        }
           statement = nil
       }
//    
//    func SearchData(Tblname: String, ColumnNames : NSArray, SelectALL : Bool, searchText:String ,CompletionHandler: (_ Status: Bool ,_ MSG : String , _ Result : NSMutableArray) -> ()) -> Void {
//        var statement: OpaquePointer?
//        let selectcolumn = SelectALL ? "*" : ColumnNames.componentsJoined(by: ",")
//        let selectQry = "select \(selectcolumn) from \(Tblname) WHERE employee_name LIKE \"%\(searchText)%\""
//        print(selectQry)
//        
//        if sqlite3_prepare_v2(DBConnect(), selectQry, -1, &statement, nil) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
//            print("error preparing select: \(errmsg)")
//        }
//        
//        let arrResult = NSMutableArray()
//        
//        while sqlite3_step(statement) == SQLITE_ROW {
//            let dic_row = NSMutableDictionary()
//         
//            for i in 0..<sqlite3_column_count(statement){
//                var Name = ""
//                var Value = ""
//                if let cString = sqlite3_column_name(statement, i) {
//                    Name = String(cString: cString)
//                    print("name = \(Name)")
//                }else{
//                    print("name not found")
//                }
//                
//                if let cString = sqlite3_column_text(statement, i) {
//                    Value = String(cString: cString)
//                    print("name = \(Value)")
//                } else {
//                    print("Value not found")
//                }
//             dic_row .setValue(Value.fromBase64(), forKey: Name)
//            }
//         
//         
//         
//         let employeObj = Employee(id: dic_row["empID"] as! String, employee_name: dic_row["employee_name"] as! String, employee_salary: dic_row["employee_name"] as! String, employee_age: dic_row["employee_name"] as! String, profile_image: dic_row["employee_name"] as? String ?? "")
//             
//         arrResult.add(employeObj)
//        }
//     
//        print(arrResult)
//     
//        if sqlite3_finalize(statement) != SQLITE_OK {
//            let errmsg = String(cString: sqlite3_errmsg(DBConnect())!)
//            print("error finalizing prepared statement: \(errmsg)")
//        }
//        else
//        {
//         CompletionHandler(true,"result",arrResult)
//     }
//        statement = nil
//    }
       
    
    
}
