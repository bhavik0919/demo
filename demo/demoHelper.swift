
import UIKit

class demoHelper: NSObject {
    var databasename = "database.sqlite"
    static let sharedInstance: demoHelper = {
        let instance = demoHelper()
        return instance
    }()
 
    func deleteolddata() -> Bool
    {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let databasePath  = documentsURL.appendingPathComponent(databasename)
        
        let strdatabasepath = databasePath.absoluteString
        
        let dirDB = FMDatabase(path: strdatabasepath)
        
        dirDB?.open()
        
        let deletequery  = NSString(format:"delete from songs")
        
        let result = dirDB?.executeUpdate(deletequery as String, withArgumentsIn: nil)
        
        dirDB?.close()
        
        return result!
    }
    
    func InsertData(data:NSArray) -> Bool
    {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let databasePath  = documentsURL.appendingPathComponent(databasename)
        
        let strdatabasepath = databasePath.absoluteString
        
        let dirDB = FMDatabase(path: strdatabasepath)
        
        dirDB?.open()
        
        var insertSQL = ""
        
        for i in 0..<data.count
        {
            //insertSQL += NSString(format: "INSERT INTO songs     (,sessionid,mobile,email,address,companyname,workaddress,photo,designation,worknumber,personalurl,companyurl,SessionType,CreatedDate,othernumber,otheraddress,otherurl,othermail,workmail) VALUES ('\(firstname + LastName)','\("HUB" + " # " + self.sessionid1)','\(MobilePhone)','\(EmailAddress)','\(PostalAddress)','\(Organization)','\(WorkAddress)','\(Image)','\(Designation)','\(Worknumber)','\(WorkUrl)','\(CompanyUrl)','\(self.SessionType)','\(CreatedDate)','\(Othernumber)','\(Otheraddress)','\(Otherurl)','\(Otheremail)','\(Workemail)');" as NSString)
            
        }
        
        let result = dirDB?.executeUpdate(insertSQL as String, withArgumentsIn: nil)
        
        dirDB?.close()
        
        return result!
    }
    
    
    func GetDataCollection() -> NSMutableArray
    {
        let  alldataarray = NSMutableArray()
        var  alldataarray2 = NSMutableArray()
        var innerDic:[String:String] = [:]
        var collectionarray = NSArray()
        var userDic : [String : AnyObject] = [:]
        var jsonarray = NSMutableArray()
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let databasePath  = documentsURL.appendingPathComponent(databasename)
        
        let strdatabasepath = databasePath.absoluteString
        
        let dirDB = FMDatabase(path: strdatabasepath)
        
        if(dirDB?.open())!{
            
            let getlistquery = "select * FROM songs GROUP BY collectionname"
            
            let results1:FMResultSet? = dirDB?.executeQuery(getlistquery,
                                                            withArgumentsIn: nil)
            while results1?.next() == true {
                
                innerDic["name"] = results1?.string(forColumn: "name")
                innerDic["sessionid"] = results1?.string(forColumn: "sessionid")
                innerDic["mobile"] = results1?.string(forColumn: "mobile")
                innerDic["email"] = results1?.string(forColumn: "email")
                innerDic["address"] = results1?.string(forColumn: "address")
                innerDic["companyname"] = results1?.string(forColumn: "companyname")
                innerDic["workaddress"] = results1?.string(forColumn: "workaddress")
                innerDic["photo"] = results1?.string(forColumn: "photo")
                innerDic["id"] = results1?.string(forColumn: "id")
                
                alldataarray.add(innerDic)
               
                collectionarray = alldataarray
                
            }
            dirDB?.close()
        }
        
        jsonarray = NSMutableArray()
        
        if(dirDB?.open())!{
            
            for i in 0..<collectionarray.count
            {
                let dic = collectionarray[i] as? NSDictionary
//                let sessionid1 = dics.object(forKey: "sessionid") as! String
//                let sessiontype = dics.object(forKey: "SessionType") as! String
//                let createddate = dics.object(forKey: "CreatedDate") as! String
                
                alldataarray2 = NSMutableArray()
                
                let collectionname = dic?.object(forKey: "collectionname") as! String
                
                let getlistquery = "select * FROM songs WHERE collectionname = '\(collectionname)'"
                
                let results1:FMResultSet? = dirDB?.executeQuery(getlistquery,
                                                                withArgumentsIn: nil)
                while results1?.next() == true {
                    
                    innerDic["name"] = results1?.string(forColumn: "name")
                    innerDic["sessionid"] = results1?.string(forColumn: "sessionid")
                    innerDic["mobile"] = results1?.string(forColumn: "mobile")
                    innerDic["email"] = results1?.string(forColumn: "email")
                    innerDic["address"] = results1?.string(forColumn: "address")
                    innerDic["companyname"] = results1?.string(forColumn: "companyname")
                    innerDic["workaddress"] = results1?.string(forColumn: "workaddress")
                    innerDic["photo"] = results1?.string(forColumn: "photo")
                    innerDic["id"] = results1?.string(forColumn: "id")
                    
                    alldataarray2.add(innerDic)
                    
                }
            }
            dirDB?.close()
        }
        
        userDic = ["GroupArray":collectionarray as AnyObject,
                   "SessionArray":alldataarray2 as AnyObject]
        
        jsonarray.add(userDic)
        
        return jsonarray
        
    }
}

extension UIColor {
    
    // custom color methods
    class func colorWithHex(rgbValue: UInt32) -> UIColor {
        return UIColor( red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0))
    }
    
    class func colorWithHexString(hexStr: String) -> UIColor {
        var cString:String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexStr.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if (cString.isEmpty || (cString.count) != 6) {
            return colorWithHex(rgbValue: 0xFF5300);
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return colorWithHex(rgbValue: rgbValue);
        }
    }
    
    func changeImageColor(theImageView: UIImageView, newColor: UIColor) {
        theImageView.image = theImageView.image?.withRenderingMode(.alwaysOriginal)
        theImageView.tintColor = newColor;
    }
}
