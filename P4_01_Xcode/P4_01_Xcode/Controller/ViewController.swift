//
//  ViewController.swift
//  P4_01_Xcode
//
//  Created by Halyna on 04/06/2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //add all outlets necessary
    @IBOutlet weak var buttonAddImage1: UIButton!
    @IBOutlet weak var buttonAddImage2: UIButton!
    @IBOutlet weak var buttonAddImage3: UIButton!
    @IBOutlet weak var buttonAddImage4: UIButton!
    
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    
    @IBOutlet weak var mainLayout: UIStackView!
    
    @IBOutlet var swipeAction: UIView!
    @IBOutlet weak var swipeText: UILabel!
    
    //  we need var  imageIndex for switch in the func imagePickerController
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonAddImage3.isHidden = true
        
        createSwipe()
        
        mainLayout.isUserInteractionEnabled = true
        mainLayout.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGesture)))
    }
   
    //swipe____________________________
    private func createSwipe(){
        swipeAction.isUserInteractionEnabled = true
        //mainLayout.isUserInteractionEnabled = true
        let swipeUP = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeUP.direction = .up
        //mainLayout.addGestureRecognizer(swipeUP)
        swipeAction.addGestureRecognizer(swipeUP)
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer){
        //to save collage
        guard let image = getImageFromCollage() else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
        
    }
    @objc func  TestswipeGesture(sender: UIPanGestureRecognizer){
        //to save collage
        guard let image = getImageFromCollage() else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    
    //Get a context from the main layout frame, and create an image based on its layer.
    private func getImageFromCollage() -> UIImage? { //
        UIGraphicsBeginImageContextWithOptions(mainLayout.frame.size, true, 0)
        mainLayout.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let collage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return collage
    }
    
    
 //PAN____________________________
    @objc func panGesture(sender1: UIPanGestureRecognizer) {
        switch sender1.state {
        case .began, .changed:
            moveGrid(gesture: sender1)
        case .ended:

            TestswipeGesture(sender: sender1)
            animation()
        default:
            break
        }
    }
    
    var check = false
    func moveGrid(gesture: UIPanGestureRecognizer ){
        let translation  = gesture.translation(in: mainLayout)
        if UIDevice.current.orientation == .portrait {
            if translation.y < 0 {
                mainLayout.transform = CGAffineTransform(translationX: 0, y: translation.y)
                check = true
            } else {
                mainLayout.transform = .identity
                check = false
            }
        } else {
            if translation.x < 0 {
                mainLayout.transform = CGAffineTransform(translationX: translation.x, y: 0)
            } else {
                mainLayout.transform = .identity
            }
        }
    }
    
    private func animation() {
        if UIDevice.current.orientation == .portrait {
            UIView.animate(withDuration: 5, animations: {self.mainLayout.transform = CGAffineTransform(translationX: 0, y: 1000)})
        } else {
            UIView.animate(withDuration: 5, animations: {self.mainLayout.transform = CGAffineTransform(translationX: 500, y: 0)})
        }
                UIView.animate(withDuration: 1, animations: {self.mainLayout.transform = CGAffineTransform(translationX: 0, y: 0)})
        }
//___________________
    
//change properties in landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       let swipeDirection = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        
        if UIDevice.current.orientation == .portrait {
            swipeText.text = "Swipe up to share"
            swipeDirection.direction = .up
        } else {
            swipeText.text = "Swipe left to share"
            swipeDirection.direction = .left
        }
        swipeAction.addGestureRecognizer(swipeDirection)
    }
    

    //____________________________________________________________
    // To use Image Picker from gallery
    @IBAction func AddImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        imageIndex = sender.tag
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let photo = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        switch imageIndex {
        case 0: imageForButton(chooseButton: buttonAddImage1, newImage: photo)
        case 1: imageForButton(chooseButton: buttonAddImage2, newImage: photo)
        case 2: imageForButton(chooseButton: buttonAddImage3, newImage: photo)
        case 3: imageForButton(chooseButton: buttonAddImage4, newImage: photo)
        default:
            break
        }
        
        picker.dismiss(animated: true)
    }
    
    // to update button image
    func imageForButton(chooseButton: UIButton, newImage: UIImage) {
        chooseButton.setImage(nil, for: .normal)
        chooseButton.imageView?.contentMode  = .scaleAspectFill
        chooseButton.setImage(newImage, for: .normal)
    }
    
    //change layout by clicking
    @IBAction func layoutAction(_ sender: UIButton) {
        buttonAddImage3.isHidden = true
        if sender.tag == 0 {
            hiddeImage(buttonHidden: buttonAddImage1, buttonNonHidden: buttonAddImage3)
            selectedLayout(selectedLayout: layout1)
        } else if sender.tag == 1 {
            hiddeImage(buttonHidden: buttonAddImage3, buttonNonHidden: buttonAddImage1)
            selectedLayout(selectedLayout: layout2)
        } else if sender.tag == 2 {
            buttonAddImage3.isHidden = false
            buttonAddImage1.isHidden = false
            selectedLayout(selectedLayout: layout3)
        }
    }
    
    // to update selected layout
    func alllayout() {
        layout1.setImage(UIImage(named: "Layout 1"), for: .normal)
        layout2.setImage(UIImage(named: "Layout 2"), for: .normal)
        layout3.setImage(UIImage(named: "Layout 3"), for: .normal)
    }
    //to add image "Selected"
    func selectedLayout(selectedLayout: UIButton) {
        alllayout()
        selectedLayout.setImage(UIImage(named: "Selected"), for: .normal)
    }
    
    func hiddeImage(buttonHidden: UIButton, buttonNonHidden: UIButton){
        buttonHidden.isHidden = true
        buttonNonHidden.isHidden = false
    }
}


