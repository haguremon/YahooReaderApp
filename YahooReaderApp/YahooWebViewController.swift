//
//  YahooWebViewController.swift
//  YahooReaderApp
//
//  Created by IwasakIYuta on 2021/07/07.
//

import UIKit
import WebKit//モージュル追加

class YahooWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var link = ""
    var date = ""
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = date
        // Do any additional setup after loading the view.
        if let url = URL(string: link){
            let request = URLRequest(url: url)
            self.webView.load(request)//これでwebViewに表示することができる
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
