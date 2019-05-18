//
//  InsertTVC.swift
//  Orderdrink
//
//  Created by 黃德桑 on 2019/5/16.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class InsertTVC: UITableViewController {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfdrink: UITextField!
    var sweet :String?
    var ice :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        sweet = "正常"
        ice = "正常"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func scSweet(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            sweet = "正常"
        case 1:
            sweet = "半糖"
        case 2:
            sweet = "微糖"
        case 3:
            sweet = "無糖"
        default:
            break
        }
    }
    
    @IBAction func scIce(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ice = "正常"
        case 1:
            ice = "少冰"
        case 2:
            ice = "去冰"
        case 3:
            ice = "溫的"
        default:
            break
        }
    }
    
    @IBAction func clicksubmit(_ sender: Any) {
        let url = URL(string: "https://sheetdb.io/api/v1/s52vqgmtqz71x")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let name = tfName.text ?? ""
        let drink = tfdrink.text ?? ""
        if sweet != nil , ice != nil {
            let order = Order(name: name, drink: drink, sweet: sweet!, ice: ice!)
            let dataorder = OrderData(data: [order])
            if let data = try? JSONEncoder().encode(dataorder) {
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, response, error) in
                    
                    let decoder = JSONDecoder()
                    if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), dic["created"] == 1 {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        print("error")
                    }
                    
                }
                task.resume()
            }
        }else{
            
        }
    }
    
    // MARK: - Table view data source

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
