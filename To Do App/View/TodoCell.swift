//
//  TodoCell.swift
//  To Do App
//
//  Created by ibrahim almutiry on 28/11/2021.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var todoTitleLb: UILabel!
    @IBOutlet weak var todoDateLb: UILabel!
    @IBOutlet weak var todoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
