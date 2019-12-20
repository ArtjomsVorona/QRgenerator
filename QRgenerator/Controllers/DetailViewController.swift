//
//  DetailViewController.swift
//  QRgenerator
//
//  Created by Artjoms Vorona on 20/12/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var qrImage: Data!
    var text = ""
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var qrCodeTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let image = UIImage(data: qrImage) else { return }
        qrCodeImageView.image = image
        
        if text == "" {
            qrCodeTextLabel.text = "QR code text: empty"
        } else {
            qrCodeTextLabel.text = "QR code text: " + text
        }
    }

}
