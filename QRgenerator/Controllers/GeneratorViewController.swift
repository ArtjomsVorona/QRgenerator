//
//  GeneratorViewController.swift
//  QRgenerator
//
//  Created by Artjoms Vorona on 19/12/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import CoreData
import UIKit

class GeneratorViewController: UIViewController {
    
    var items = [Items]()
    var qrImage: UIImage!
    
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var qrTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        loadData()
        
        qrTextField.attributedPlaceholder = NSAttributedString(string: "Enter your text or website.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
    }
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        if qrImage != nil {
            let newItem = Items(context: self.context!)
            newItem.qrImage = Data(qrImage.pngData()!)
            newItem.text = qrTextField.text
            items.append(newItem)
            saveData()
        } else {
            print("No image to save")
        }
    }
    
    @IBAction func generateButtonTouched(_ sender: UIButton) {
        generateQRCode()
    }
    
    func generateQRCode() {
        let text = qrTextField.text
        let data = text?.data(using: .ascii)
        
        //Creating outputImage from textField
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let outputImage = qrFilter.outputImage else { return }
        
        //Scaling the code
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = outputImage.transformed(by: transform)
        
        //Creating QR code UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let imageResult = UIImage(cgImage: cgImage)
        qrImage = imageResult
        imageView.image = imageResult
    }
    
    //MARK: - Core Data functions
    
    func saveData() {
        do {
            try context?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do {
            items = try (context?.fetch(request))!
        } catch  {
            print(error.localizedDescription)
        }
    }

}

extension GeneratorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        qrTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        qrTextField.resignFirstResponder()
    }
}