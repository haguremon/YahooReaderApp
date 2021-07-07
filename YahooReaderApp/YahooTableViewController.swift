//
//  YahooTableViewController.swift
//  YahooReaderApp
//
//  Created by IwasakIYuta on 2021/07/07.
//

import UIKit

class YahooTableViewController: UITableViewController, XMLParserDelegate {
    var parser:XMLParser!//XMLParser型のプロパティを用意
    var items = [Items]()//空のItems型の配列を用意
    var item: Items?
    var currentElementString = "" //一時的に保存するやつ
    
    
    override func viewDidLoad() {
        super.viewDidAppear(true)
        startDownload()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = items[indexPath.row].title //各セルにitemsのタイトルをつける
        return cell
    }
    //viewDidLoadに表示するやつ
    func startDownload() {
        self.items = [] //ここに記事が入る
        if let url = URL(string: "https://news.yahoo.co.jp/rss/topics/top-picks.xml") {
        if let parser = XMLParser(contentsOf: url) {
            self.parser = parser
            parser.delegate = self //ここでXMLParserDelegateでのメソッドが通知されるって認識
            self.parser.parse()//https://news.yahoo.co.jp/rss/topics/top-picks.xmlの解析開始
        }
    }
        
    }
    //1 StartElement<item>の開始タグを見つける
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElementString = ""//これが開始した時に文字列を全て入れる
        if elementName == "item" { //<item>タグを見つけたときに
            self.item = Items() //Itemsのプロパティの要素だけを入れる
        }
    }
    //2 上の<item>に囲まれた文字列の要素を取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentElementString += string //上で見つけたタグに囲まれた要素を取得
    }
    //3 didEndElement</item>の開始タグを見つける
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //self.currentElementString = ""
        switch elementName {
        case "title": self.item?.title = currentElementString
        case "link": self.item?.link = currentElementString
        case "pudDate": self.item?.pudDate = currentElementString
        case "item": self.items.append(self.item!)
        default:
            break
        }
    }
    //これでtableViewに表示する？
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {//セルがタップされた場所がわかるindexPathForSelectedRow
            let item = items[indexPath.row]
            let vc = segue.destination as! YahooWebViewController//segueのdestinationで遷移先を指定することができる
            vc.title = item.title
            vc.link = item.link
            vc.date = item.pudDate
            //self.present(vc, animated: true)//値を渡して遷移
        }
    }
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
