//
//  LeaveCustomCell.swift
//  HrisApp
//
//  Created by Cognisun on 14/12/17.
//  Copyright © 2017 Cognisun. All rights reserved.
//

import UIKit


class CustomCell : UITableViewCell {
    
    @IBOutlet weak var lblname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}



