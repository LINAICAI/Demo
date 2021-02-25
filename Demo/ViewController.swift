//
//  ViewController.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func loadData() {
        let request = ZKRURLRequest("https://api.github.com/")
        request.sendAsynchronousWithCompletion { (_, response: ZKRURLResponse<Any>?, _) in
            
            debugPrint(response)
        }
    }
}
