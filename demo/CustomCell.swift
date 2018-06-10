//
//  LeaveCustomCell.swift
//  HrisApp
//
//  Created by Cognisun on 14/12/17.
//  Copyright © 2017 Cognisun. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCell : UITableViewCell {
    
    @IBOutlet weak var trackimage: UIImageView!
    @IBOutlet weak var playerbutton: customebutton!
    
    @IBOutlet weak var lblname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var tapAction: ((UITableViewCell) -> Void)?
    @IBAction func playAudio(_ sender: Any) {
        tapAction?(self)
    }
    
}

class customebutton: UIButton {
    var section:Int?
    var row:Int?
}


