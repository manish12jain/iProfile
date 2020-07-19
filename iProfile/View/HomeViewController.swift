//
//  HomeViewController.swift
//  iProfile
//
//  Created by pc on 7/18/20.
//  Copyright © 2020 Manish Jain. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnLoadProfile: UIButton!
    
    var homeVM = HomeViewModel()
    var activityView: UIActivityIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        SqliteHelper.sharedInstance.CreateALLTables()
        addActivityIndicator()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SqliteHelper.sharedInstance.SelectData(Tblname:  TBL_EMP, ColumnNames: [], SelectALL: true)
         { (status, MSG,  dic_result) in
            print(MSG)
            print(dic_result)
            
            if (dic_result.count == 0)
            {
                self.btnLoadProfile.setTitle(Constants.profileLoadText, for: .normal)
            }
            else
            {
                self.btnLoadProfile.setTitle(Constants.profileLoadedText, for: .normal)
            }
        }
    }
    
    func addActivityIndicator() {
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityView?.center =  CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        activityView?.hidesWhenStopped = true
        view.addSubview(activityView!)
    }
    
    @IBAction func loadProfilesTapped(_ sender: Any)
    {
        loadAndSaveEmployee()
    }
    
    /// This method is to get Employees data from ViewModel
   func loadAndSaveEmployee() {
    
    SqliteHelper.sharedInstance.SelectData(Tblname:  TBL_EMP, ColumnNames: [], SelectALL: true)
     { (status, MSG,  dic_result) in
        print(MSG)
        print(dic_result)
        
        if (dic_result.count != 0)
        {
            self.deleteAndFetchData()
        }
        else
        {
            self.fetchData()
        }
    }
    
    }
    
   func deleteAndFetchData()
   {
        self.btnLoadProfile.setTitle(Constants.profileDeletedText, for: .normal)

        SqliteHelper.sharedInstance.DeleteData(Tblname: TBL_EMP) { (status, msg) in
            
            if (status)
            {
                self.fetchData()
            }
        }
   }
   
   func fetchData()
   {
     activityView?.startAnimating()
       homeVM.getEmployeeData
       { result in
 
        self.activityView?.stopAnimating()
          switch(result){
          case .success:
              self.btnLoadProfile.setTitle(Constants.profileLoadedText, for: .normal)
          case .failure(let error):
              Utils.showAlert(message: error.localizedDescription, viewcontroller: self, action: UIAlertAction(title: Constants.ok, style: .default, handler: nil))
          }
      }
   }
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
