
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
                let dataobj = data[i] as? NSDictionary
                
                let artistId = String(dataobj?.object(forKey: DataDic.artistId) as! Int)
                let artistName = dataobj?.object(forKey: DataDic.artistName) as! String
                let artistViewUrl = dataobj?.object(forKey: DataDic.artistViewUrl) as! String
                let artworkUrl100 = dataobj?.object(forKey: DataDic.artworkUrl100) as! String
                let artworkUrl30 = dataobj?.object(forKey: DataDic.artworkUrl30) as! String
                let artworkUrl60 = dataobj?.object(forKey: DataDic.artworkUrl60) as! String
                let collectionCensoredName = dataobj?.object(forKey: DataDic.collectionCensoredName) as! String
                let collectionExplicitness = dataobj?.object(forKey: DataDic.collectionExplicitness) as! String
                let collectionName = dataobj?.object(forKey: DataDic.collectionName) as! String
                let collectionId = String(dataobj?.object(forKey: DataDic.collectionId) as! Int)
                let collectionViewUrl = dataobj?.object(forKey: DataDic.collectionViewUrl) as! String
                let previewUrl = dataobj?.object(forKey: DataDic.previewUrl) as! String
                let trackId = String(dataobj?.object(forKey: DataDic.trackId) as! Int)
                let trackName = dataobj?.object(forKey: DataDic.trackName) as! String
                let trackViewUrl = dataobj?.object(forKey: DataDic.trackViewUrl) as! String
                
                insertSQL += "INSERT INTO songs (Id,artistId,artistName,artistViewUrl,artworkUrl100,artworkUrl30,artworkUrl60,collectionCensoredName,collectionExplicitness,collectionId,collectionName,collectionViewUrl,previewUrl,trackId,trackName,trackViewUrl) VALUES (null,\(artistId),'\(artistName)','\(artistViewUrl)','\(artworkUrl100)','\(artworkUrl30)','\(artworkUrl60)','\(collectionCensoredName)','\(collectionExplicitness)',\(collectionId),'\(collectionName)','\(collectionViewUrl)','\(previewUrl)',\(trackId),'\(trackName)','\(trackViewUrl)');"
                
            }
            
            result = database.executeStatements(insertSQL)
            
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
               
                innerDic["collectionId"] = results1?.string(forColumn: "collectionId")
                innerDic["collectionName"] = results1?.string(forColumn: "collectionName")
                innerDic["collectionViewUrl"] = results1?.string(forColumn: "collectionViewUrl")
                innerDic["collectionCensoredName"] = results1?.string(forColumn: "collectionCensoredName")
                innerDic["collectionExplicitness"] = results1?.string(forColumn: "collectionExplicitness")
                innerDic["Id"] = results1?.string(forColumn: "Id")
                
                alldataarray.add(innerDic)
               
                collectionarray = alldataarray
                
            }
           
        }
        
        jsonarray = NSMutableArray()
        
        if(openDatabase()){
            
            for i in 0..<collectionarray.count
            {
                
                let dic = collectionarray[i] as? NSDictionary
                
                alldataarray2 = NSMutableArray()
                
                let collectionname = dic?.object(forKey: "collectionName") as! String
                
                let getlistquery = "select * FROM songs WHERE collectionName = '\(collectionname)'"
                
                let results1:FMResultSet? = database.executeQuery(getlistquery,
                                                                withArgumentsIn: nil)
                while results1?.next() == true {
    
                    innerDic["artistId"] = results1?.string(forColumn: "artistId")
                    innerDic["artistName"] = results1?.string(forColumn: "artistName")
                    innerDic["artistViewUrl"] = results1?.string(forColumn: "artistViewUrl")
                    innerDic["artworkUrl100"] = results1?.string(forColumn: "artworkUrl100")
                    innerDic["artworkUrl30"] = results1?.string(forColumn: "artworkUrl30")
                    innerDic["previewUrl"] = results1?.string(forColumn: "previewUrl")
                    innerDic["trackId"] = results1?.string(forColumn: "trackId")
                    innerDic["trackName"] = results1?.string(forColumn: "trackName")
                    innerDic["trackViewUrl"] = results1?.string(forColumn: "trackViewUrl")
                    innerDic["Id"] = results1?.string(forColumn: "Id")
                    
                    alldataarray2.add(innerDic)
                    
                }
                
                userDic = ["collectiondic":dic as AnyObject,
                           "songarray":alldataarray2 as AnyObject]
                
                jsonarray.add(userDic)
                
            }
            
        }
        
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
