//
//  ViewController.swift
//  demo
//
//  Created by Bhavik Panchal on 5/24/18.
//  Copyright © 2018 bhavik. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate  {
    var boolValue = false
    @IBOutlet var tableview: UITableView!
    var queue = OperationQueue()
    @IBOutlet weak var searchbar: UISearchBar!
    
    let kHeaderSectionTag: Int = 6900;
    
    var userDic : [String : AnyObject] = [:]
    var CategoryArray = NSMutableArray()
    var SongArray = NSMutableArray()
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var jsonarray = NSMutableArray()

    var dataArr = NSArray()
    var collectionarray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.GetData(search: searchbar.text!)
    }
    func GetData(search:String)
    {
      
        let parameter : [String:Any] = ["":""]
        
        APIClient.GetApi(url: ApiMethodName.searchapi + search, parameter as [String : AnyObject] , completion: { (data, error)->Void in
            if((error) != nil) {
                
                
            } else
            {
                if((data) != nil){
                    
                    let result = data?.object(forKey: "results") as! NSArray
                    if(result.count > 0)
                    {
                        
                        if(demoHelper.sharedInstance.deleteolddata())
                        {
                            if(demoHelper.sharedInstance.InsertData(data: result))
                            {
                                self.jsonarray = demoHelper.sharedInstance.GetDataCollection() as NSMutableArray
                                self.tableview.reloadData()
                            }
                            else
                            {
                                print("failer insert")
                            }
                        }
                        else
                        {
                            print("fail delete")
                        }
                        
                    }
                    
                } else
                {
                    
                }
                
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.jsonarray.count > 0 {
            tableView.backgroundView = nil
            return self.jsonarray.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableview.backgroundView = messageLabel;
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let dataofsection = self.jsonarray[section] as? NSDictionary
            let arrayOfItems = dataofsection?.object(forKey: "songarray") as? NSMutableArray
            return arrayOfItems!.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (self.jsonarray.count != 0) {
            let dataofsection = self.jsonarray[section] as? NSDictionary
            let collectiondic = dataofsection?.object(forKey: "collectiondic") as? NSDictionary
            let collectionname = collectiondic?.object(forKey: "collectionName") as! String
            return collectionname
        }
        return ""
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.colorWithHexString(hexStr: "#408000")
        header.textLabel?.textColor = UIColor.white
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    @objc func tickClicked(_ sender: customebutton!) {
        
        //let cellTop = tableview.cellForRow(at: NSIndexPath(row: sender.tag, section: sender.section!) as IndexPath) as!CustomCell
        
        if boolValue == false{
            //cellTop.playerbutton.setImage(UIImage(named:"Pause.png"), for: UIControlState.normal)
            boolValue = true
        } else {
            //cellTop.playerbutton.setImage(UIImage(named:"Play.png"), for: UIControlState.normal)
            boolValue = false
        }
    }

    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.jsonarray[section] as? NSDictionary
        let arrayOfItems = sectionData?.object(forKey: "songarray") as! NSMutableArray
        
        self.expandedSectionHeaderNumber = -1;
        if (arrayOfItems.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< arrayOfItems.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableview!.beginUpdates()
            self.tableview!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableview!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.jsonarray[section] as? NSDictionary
        let arrayOfItems = sectionData?.object(forKey: "songarray") as! NSMutableArray
        
        
        if (arrayOfItems.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< arrayOfItems.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableview!.beginUpdates()
            self.tableview!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableview!.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        
        let sectionData = self.jsonarray[indexPath.section] as? NSDictionary
        let items = sectionData?.object(forKey: "songarray") as! NSMutableArray
        
        let dic = items[indexPath.row] as! NSDictionary
       
        cell.lblname.text = dic.object(forKey: DataDic.trackName) as? String
        
        cell.playerbutton.tag = indexPath.row
        cell.playerbutton.section = indexPath.row
        
        cell.playerbutton!.backgroundColor = UIColor.lightGray
        cell.playerbutton!.setTitle("Play", for: UIControlState.normal)
        cell.playerbutton!.tintColor = UIColor.black
        
        cell.playerbutton.addTarget(self, action: #selector(tickClicked), for: .touchUpInside)
        cell.tag = indexPath.row
        
        let url = URL(string: (dic.object(forKey: DataDic.previewUrl) as? String)!)
        
        let playerItem = AVPlayerItem(url: url!)
        cell.avplayer = AVPlayer(playerItem:playerItem)
        
        cell.tapAction = { (cell2) in
            if cell.avplayer.rate == 0 {
                cell.avplayer?.play()
                cell.playerbutton!.setTitle("Pause", for: UIControlState.normal)
                cell.avplayer?.rate = 1.0
            } else if cell.avplayer?.rate == 1{
                cell.avplayer?.pause()
                cell.playerbutton!.setTitle("Play", for: UIControlState.normal)
            }
        }

        var img: UIImage!
        
        let operation = BlockOperation(block: {
            img = Downloader.downloadImageWithURl(dic.object(forKey: DataDic.artworkUrl100) as! String)
        })
        
        operation.completionBlock = {
            DispatchQueue.main.async {
                if(img != nil)
                {
                    cell.trackimage?.image = img
                }
                
            }
            
        }
        queue.addOperation(operation)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       

    }
}

class Downloader {
    class func downloadImageWithURl(_ url: String) -> UIImage! {
        if let data = try? Data(contentsOf: URL(string: url)!) {
            if(data != nil)
            {
              return UIImage(data: data)!
            }
            else
            {
              return nil
            }
            
        }
        return nil
    }
    
}

