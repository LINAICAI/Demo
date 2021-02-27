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
    private let timeInterval: TimeInterval = 5.0

    private let requestKey: String = "request"
    private let lastRequestCache: Defaults = Defaults()

    private let histroyKey: String = "histroy"
    private let histroyCache: Defaults = Defaults()

    private let historyController = TableViewController(style: .plain)

    lazy var rightBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "历史记录", style: .done, target: self, action: #selector(history))
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = rightBarButtonItem

        textView.text = lastRequestCache[requestKey] as? String
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)
    }

    @objc func loadData() {
        let request = ZKRURLRequest("https://api.github.com/")
        request.sendAsynchronousWithCompletion { (_, result: Any?, error) in
            DispatchQueue.main.async { [self] in
                if let _ = error {
                    debugPrint("request error")
                } else {
                    debugPrint("\(String(describing: result as? String))")
                    textView.text = result as? String

                    lastRequestCache[requestKey] = result as? String

                    if var history = histroyCache[histroyKey] as? Array<Date> {
                        history.insert(Date(), at: 0)
                        histroyCache[histroyKey] = history
                    } else {
                        histroyCache[histroyKey] = [Date()]
                    }
                    historyController.showNewMessage()
                }
            }
        }
    }

    @objc func history() {
        navigationController?.pushViewController(historyController, animated: true)
    }
}
