//
//  ViewController.swift
//  simplemath-helper
//
//  Created by Vineeth Vijayan on 15/08/16.
//  Copyright © 2016 Vineeth Vijayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSend(_ sender: AnyObject) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://fcm.googleapis.com/fcm/send")! as URL)
        
        let num1 = Int.random(lower: 1, 100)
        var num2 = Int.random(lower: 1, 100)
        let actionNumber = Int.random(lower: 1, 3)
        var action = "+"
        var result = 0
        
        switch actionNumber {
        case 1:
            action = "+"
            result = num1 + num2
            break
        case 2:
            action = "-"
            if num1 < num2 {
                num2 = Int.random(lower: 0, num1)
            }
            result = num1 - num2
            
            break
        case 3:
            action = "*"
            num2 = Int.random(lower: 0, 20)
            result = num1 * num2
            break
        case 4:
            action = "/"
            if num1 > num2 {
                result = num1 / num2
            }
            else{
                result = num2 / num1
            }
        default:
            action = "+"
            result = num1 + num2
        }
        
        request.httpMethod = "POST"
        
        request.addValue("key=AIzaSyD-jHhTOQ2Ku82wykZ5b3wGC-J8yOtajxA", forHTTPHeaderField: "authorization")
        
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        let message = num1.description + action + num2.description
        
        let postString = "{    \"to\" : \"/topics/allusers\",    \"notification\" : {        \"body\" : \"" + message + "\",        \"click_action\": \"CATEGORY_ID\"    },    \"data\": {        \"num1\": \"" + num1.description + "\",        \"num2\": \"" + num2.description + "\",        \"action\": \"" + action + "\",        \"result\": \"" + result.description + "\"    },    \"priority\": \"high\",    \"content_available\": true}"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
        }
        task.resume()
    }

}

public extension Int {
    /// SwiftRandom extension
    public static func random(range: Range<Int>) -> Int {
        return random(lower: range.lowerBound, range.upperBound)
    }
    
    /// SwiftRandom extension
    public static func random(lower: Int = 0, _ upper: Int = 100) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}


