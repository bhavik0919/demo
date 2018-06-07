
import UIKit

class demoHelper: NSObject {
   
    let databaseFileName = "database.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
   
    
    static let sharedInstance: demoHelper = {
        let instance = demoHelper()
        return instance
    }()
 
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createMoviesTableQuery = "create table songs (\(DataDic.Id) integer primary key autoincrement not null, \(DataDic.artistId) text, \(DataDic.artistName) text,\(DataDic.artistViewUrl) text,\(DataDic.artworkUrl100) text,\(DataDic.artworkUrl30) text,\(DataDic.artworkUrl60) text,\(DataDic.collectionCensoredName) text,\(DataDic.collectionExplicitness) text,\(DataDic.collectionId) text,\(DataDic.collectionName) text,\(DataDic.collectionViewUrl) text,\(DataDic.previewUrl) text,\(DataDic.trackId) text,\(DataDic.trackName) text,\(DataDic.trackViewUrl) text)"
                    
                    do {
                        try database.executeUpdate(createMoviesTableQuery, withArgumentsIn: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func deleteolddata() -> Bool
    {
        var result = false;
        
        if openDatabase() {
           
            let deletequery  = NSString(format:"delete from songs")
            
            result = database.executeUpdate(deletequery as String, withArgumentsIn: nil)
            
            
        }
        
        return result
    }
    
    func InsertData(data:NSArray) -> Bool
    {
        var result = false
        
        var insertSQL = ""
        
        if(openDatabase())
        {
            for i in 0..<data.count
            {
                
                let createMoviesTableQuery = "create table songs (\(DataDic.Id) integer primary key autoincrement not null, \(DataDic.artistId) text, \(DataDic.artistName) text,\(DataDic.artistViewUrl) text,\(DataDic.artworkUrl100) text,\(DataDic.artworkUrl30) text,\(DataDic.artworkUrl60) text,\(DataDic.collectionCensoredName) text,\(DataDic.collectionExplicitness) text,\(DataDic.collectionId) text,\(DataDic.collectionName) text,\(DataDic.collectionViewUrl) text,\(DataDic.previewUrl) text,\(DataDic.trackId) text,\(DataDic.trackName) text,\(DataDic.trackViewUrl) text)"
                
                insertSQL += NSString(format: "INSERT INTO songs (Id,artistId,artistName,artistViewUrl,artworkUrl100,artworkUrl30,artworkUrl60,collectionCensoredName,collectionExplicitness,collectionId,collectionName,collectionViewUrl,previewUrl,trackId,trackName,trackViewUrl) VALUES (null,'','','','','','','','','','','','','','','');" as NSString) as String
                
            }
            
            
            
            result = database.executeUpdate(insertSQL as String, withArgumentsIn: nil)
            
        }
       
        
        return result
    }
    
    
    func GetDataCollection() -> NSMutableArray
    {
        let  alldataarray = NSMutableArray()
        var  alldataarray2 = NSMutableArray()
        var innerDic:[String:String] = [:]
        var collectionarray = NSArray()
        var userDic : [String : AnyObject] = [:]
        var jsonarray = NSMutableArray()

        if(openDatabase()){
            
            let getlistquery = "select * FROM songs GROUP BY collectionname"
            
            let results1:FMResultSet? = database.executeQuery(getlistquery,
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
           
        }
        
        jsonarray = NSMutableArray()
        
        if(openDatabase()){
            
            for i in 0..<collectionarray.count
            {
                let dic = collectionarray[i] as? NSDictionary
//                let sessionid1 = dics.object(forKey: "sessionid") as! String
//                let sessiontype = dics.object(forKey: "SessionType") as! String
//                let createddate = dics.object(forKey: "CreatedDate") as! String
                
                alldataarray2 = NSMutableArray()
                
                let collectionname = dic?.object(forKey: "collectionname") as! String
                
                let getlistquery = "select * FROM songs WHERE collectionname = '\(collectionname)'"
                
                let results1:FMResultSet? = database.executeQuery(getlistquery,
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
