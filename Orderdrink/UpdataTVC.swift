//
//  UpdataTVC.swift
//  Orderdrink
//
//  Created by 黃德桑 on 2019/5/18.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class UpdataTVC: UITableViewController {
    var order : Order?
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfdrink: UITextField!
    @IBOutlet weak var scsweet: UISegmentedControl!
    @IBOutlet weak var scice: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = "姓名 :   \(order!.name)"
        tfdrink.text = order?.drink
        switch order?.sweet {
        case "正常":
            scsweet.selectedSegmentIndex = 0
        case "半糖":
            scsweet.selectedSegmentIndex = 1
        case "微糖":
            scsweet.selectedSegmentIndex = 2
        case "無糖":
            scsweet.selectedSegmentIndex = 3
        default:
            break
        }
        
        switch order?.ice {
        case "正常":
            scice.selectedSegmentIndex = 0
        case "少冰":
            scice.selectedSegmentIndex = 1
        case "去冰":
            scice.selectedSegmentIndex = 2
        case "溫的":
            scice.selectedSegmentIndex = 3
        default:
            break
        }
        

        
    }

    // MARK: - Table view data source
    @IBAction func scSweet(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            order!.sweet = "正常"
        case 1:
            order!.sweet = "半糖"
        case 2:
            order!.sweet = "微糖"
        case 3:
            order!.sweet = "無糖"
        default:
            break
        }
    }
    
    @IBAction func scIce(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            order!.ice = "正常"
        case 1:
            order!.ice = "少冰"
        case 2:
            order!.ice = "去冰"
        case 3:
            order!.ice = "溫的"
        default:
            break
        }
        
    }
    
    @IBAction func clicksubmit(_ sender: UIButton) {
        order?.drink = tfdrink.text ?? ""
        let url = URL(string: "https://sheetdb.io/api/v1/s52vqgmtqz71x/name/\(order!.name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataorder = OrderData(data: [order!])
        if let data = try? JSONEncoder().encode(dataorder) {
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, response, error) in
                
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try? decoder.decode([String: Int].self, from: retData), dic["updated"] == 1 {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("error")
                }
                
            }
            task.resume()
        }
    }
    
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
