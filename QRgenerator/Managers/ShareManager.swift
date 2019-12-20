//
//  ShareManager.swift
//  QRgenerator
//
//  Created by Artjoms Vorona on 20/12/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import UIKit

class ShareManager {
    
    func sharePngImage(image: UIImage, vc: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: [image] as [Any], applicationActivities: nil)
        vc.present(activityVC, animated: true, completion: nil)
    }
    
}
