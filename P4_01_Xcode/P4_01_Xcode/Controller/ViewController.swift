//
//  ViewController.swift
//  P4_01_Xcode
//
//  Created by Halyna on 04/06/2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var buttonAddImage1: UIButton!
    @IBOutlet weak var buttonAddImage2: UIButton!
    @IBOutlet weak var buttonAddImage3: UIButton!
    @IBOutlet weak var buttonAddImage4: UIButton!
    
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    
    var testArray = ["Layout 1","Layout 1"] // need to change. Use only fo test
    @IBOutlet weak var swipeAction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        swipeAction.isUserInteractionEnabled = true
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeUP.direction = UISwipeGestureRecognizer.Direction.up
        swipeAction.addGestureRecognizer(swipeUP)
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer){
        let shareController = UIActivityViewController(activityItems: testArray, applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func AddImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let photo = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        buttonAddImage1.setImage(photo.withRenderingMode(.alwaysOriginal), for: .normal)
        buttonAddImage1.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    
   //change layout by clicking
    @IBAction func layoutAction(_ sender: UIButton) {
        if sender.tag == 0 {
            buttonAddImage1.isHidden = true
            buttonAddImage3.isHidden = false
            layout1.setImage(UIImage(named: "Selected"), for: .normal)
            layout2.setImage(UIImage(named: "Layout 2"), for: .normal)
            layout3.setImage(UIImage(named: "Layout 3"), for: .normal)
            
        } else if sender.tag == 1 {
            buttonAddImage1.isHidden = false
            buttonAddImage3.isHidden = true
            layout2.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.setImage(UIImage(named: "Layout 1"), for: .normal)
            layout3.setImage(UIImage(named: "Layout 3"), for: .normal)
        } else if sender.tag == 2 {
            buttonAddImage3.isHidden = false
            buttonAddImage1.isHidden = false
            layout3.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.setImage(UIImage(named: "Layout 1"), for: .normal)
            layout2.setImage(UIImage(named: "Layout 2"), for: .normal)
        }
    }
}

