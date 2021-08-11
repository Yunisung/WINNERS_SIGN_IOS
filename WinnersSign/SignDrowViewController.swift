//
//  SignDrowViewController.swift
//  WinnersSign
//
//  Created by NoteBook-2389 on 2021/04/12.
//

import UIKit


class SignDrowViewController: UIViewController {

    @IBOutlet weak var signImageView: UIImageView!
    
    var delegate: SignProtocol?
    
    var fileName: String = ""
    var isDrowCheck: Bool = false
    
    var lastPoint: CGPoint!
    
    var lineSize:CGFloat = 3.0
    
    var lineColor = UIColor.black.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isDrowCheck = false
        
        signImageView.layer.borderWidth = 1
        signImageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @IBAction func didTapSignDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
        
            if self.isDrowCheck == false {
                self.fileName = ""
            } else {
                self.SaveImage()
                let data = self.signImageView.image?.pngData()
                let bytes = ImageFileManager.shared.getArrayOfBytesFromImage(imageData: data! as NSData)
                self.delegate?.SignData(fileName: self.fileName, data: bytes)
            }
            
        })
    }
    
    @IBAction func didTapReSign(_ sender: UIButton) {
        ClearImage()
    }
    

    func SaveImage() {
        ImageFileManager.shared.saveImage(image: signImageView.image!, name: fileName) {
            [weak self] onSuccess in print("saveImage \(self!.fileName) onSuccess:\(onSuccess)")
        }
    }
    
    func LoadImage() {
        if let image: UIImage = ImageFileManager.shared.getSavedImage(named: fileName) {
            signImageView.image = image
        }
    }
    
    func ClearImage() {
        signImageView.image = nil
        isDrowCheck = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        lastPoint = touch.location(in: signImageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(signImageView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        let touch = touches.first! as UITouch
        
        let currPoint = touch.location(in: signImageView)
        
        signImageView.image?.draw(in: CGRect(x: 0, y: 0, width: signImageView.frame.size.width, height: signImageView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        signImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        
        lastPoint = currPoint
        isDrowCheck = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(signImageView.frame.size)
        UIGraphicsGetCurrentContext()?.setStrokeColor(lineColor)
        UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
        UIGraphicsGetCurrentContext()?.setLineWidth(lineSize)
        
        let touch = touches.first! as UITouch
        let currPoint = touch.location(in: signImageView)
        
        signImageView.image?.draw(in: CGRect(x: 0, y: 0, width: signImageView.frame.size.width, height: signImageView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        signImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        isDrowCheck = true
    }

}
