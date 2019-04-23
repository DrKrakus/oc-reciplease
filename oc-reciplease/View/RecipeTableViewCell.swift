//
//  RecipeTableViewCell.swift
//  oc-reciplease
//
//  Created by Jerome Krakus on 23/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(imgURL: String, title: String, ratio: Int, duration: Int) {
        // Change the size of image by modifying the URL
        let biggerImgUrl = imgURL.replacingOccurrences(of: "=s90", with: "=s300")

        // Configure the cell
        self.imageBackground.load(URL(string: biggerImgUrl)!)
        self.titleLabel.text = title
        self.ratioLabel.text = String(ratio)
        self.durationLabel.text = String(duration / 60) + " min"
    }
}
