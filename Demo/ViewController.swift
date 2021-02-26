//
//  ViewController.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var textView: UITextView!

    private var timer: Timer?
    private var timeInterval: TimeInterval = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }

    @objc func loadData() {
        let request = ZKRURLRequest("https://api.github.com/")
        request.sendAsynchronousWithCompletion { (_, result: Any?, _) in
            DispatchQueue.main.async { [self] in
                textView.text = result as? String
            }
        }
    }
}
