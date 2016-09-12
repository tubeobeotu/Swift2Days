//
//  TrackCell.swift
//  HalfTunes
//
//  Created by Ken Toh on 13/7/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
    func pauseTapped(cell: TrackCell)
    func resumeTapped(cell: TrackCell)
    func cancelTapped(cell: TrackCell)
    func downloadTapped(cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    var delegate: TrackCellDelegate?
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBAction func pauseOrResumeTapped(sender: AnyObject) {
        if(pauseButton.titleLabel!.text == "Pause") {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(sender: AnyObject) {
        delegate?.downloadTapped(self)
    }
    
    
    func configureCell(track : Track) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
        
        if let imageUrl = track.imageUrl {
            
            let infoOptions : KingfisherOptionsInfo = [.Transition(.Fade(1)),
                                                       .CacheMemoryOnly,
                                                       .BackgroundDecode]
            
            
            myImageView.kf_setImageWithURL(NSURL(string: imageUrl),
                                           placeholderImage: nil,
                                           optionsInfo: infoOptions)
            
        }
    }
}
