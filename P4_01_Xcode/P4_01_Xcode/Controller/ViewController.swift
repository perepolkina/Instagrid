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
    
    @IBOutlet weak var swipeText: UILabel!
    
    //for switch in the func imagePickerController
    var imageIndex = 0
    //to set the orientation after launching the application
    var deviceOrientation : UIDeviceOrientation = .portrait
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonAddImage3.isHidden = true
        
        configurationOrientation()
        mainLayout.isUserInteractionEnabled = true
        mainLayout.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGesture)))
    }
    
    // to change var deviceOrientation
    private func configurationOrientation() {
        if screenHeight > screenWidth {
            swipeText.text = "Swipe up to share"
            deviceOrientation = .portrait
        } else {
            swipeText.text = "Swipe left to share"
            deviceOrientation = .landscapeLeft
        }
    }
    
    //Logic of PanGestureRecognizer
    //status of PanGestureRecognizer
    @objc func panGesture(senderPan: UIPanGestureRecognizer) {
        switch senderPan.state {
        case .began, .changed:
            moveGrid(gesture: senderPan)
        case .ended:
            if checkPosition{
                shareImage(sender: senderPan)
                animation()
            }
        default:
            break
        }
    }
    //to move GridView according to orientation (animation swipe)
    var checkPosition = false
    func moveGrid(gesture: UIPanGestureRecognizer ){
        let translation  = gesture.translation(in: mainLayout)
        if deviceOrientation == .portrait {
            if translation.y < 0 {
                mainLayout.transform = CGAffineTransform(translationX: 0, y: translation.y)
                checkPosition = true
            } else {
                mainLayout.transform = .identity
                checkPosition = false
            }
        } else {
            if translation.x < 0 {
                mainLayout.transform = CGAffineTransform(translationX: translation.x, y: 0)
                checkPosition = true
            } else {
                mainLayout.transform = .identity
                checkPosition = false
            }
        }
    }
    //animation for swipe
    private func animation() {
        if deviceOrientation == .portrait {
            UIView.animate(withDuration: 1, animations: {self.mainLayout.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)})
        } else {
            UIView.animate(withDuration: 1, animations: {self.mainLayout.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)})
        }
    }
    
    
    //to  save collages and to share it
    @objc func shareImage(sender: UIPanGestureRecognizer) {
        guard let image = getImageFromCollage() else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = { (_ , _ , _ , error) in
            guard error == nil else {
                return
            }
            //it calls a function to put mainLayout back in the right place
            UIView.animate(withDuration: 0.5, animations: {self.mainLayout.transform = CGAffineTransform(translationX: 0, y: 0)})
        }
        present(shareController, animated: true, completion: nil)
    }
    
    //get a context from the main layout frame, and create an image based on its layer.
    private func getImageFromCollage() -> UIImage? { //
        UIGraphicsBeginImageContextWithOptions(mainLayout.frame.size, true, 0)
        mainLayout.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let collage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return collage
    }
    
    //change text in landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation == .portrait {
            swipeText.text = "Swipe up to share"
            deviceOrientation = .portrait
        } else {
            swipeText.text = "Swipe left to share"
            deviceOrientation = .landscapeLeft
        }
    }
    
    // Logic of the image Picker
    // to choosen and to add image from gallery
    @IBAction func addImage(_ sender: UIButton) {
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
    
    //change GridView by choosing layout (hide button if it's necessary)
    @IBAction func layoutAction(_ sender: UIButton) {
        buttonAddImage3.isHidden = true
        if sender.tag == 0 {
            hideImage(buttonHidden: buttonAddImage1, buttonNonHidden: buttonAddImage3)
            selectedLayout(selectedLayout: layout1)
        } else if sender.tag == 1 {
            hideImage(buttonHidden: buttonAddImage3, buttonNonHidden: buttonAddImage1)
            selectedLayout(selectedLayout: layout2)
        } else if sender.tag == 2 {
            buttonAddImage3.isHidden = false
            buttonAddImage1.isHidden = false
            selectedLayout(selectedLayout: layout3)
        }
    }
    
    func hideImage(buttonHidden: UIButton, buttonNonHidden: UIButton){
        buttonHidden.isHidden = true
        buttonNonHidden.isHidden = false
    }
    
    // to update all layouts
    func updateAllLayouts() {
        layout1.setImage(UIImage(named: "Layout 1"), for: .normal)
        layout2.setImage(UIImage(named: "Layout 2"), for: .normal)
        layout3.setImage(UIImage(named: "Layout 3"), for: .normal)
    }
    
    //to add image "Selected" to the selected layout
    func selectedLayout(selectedLayout: UIButton) {
        updateAllLayouts()
        selectedLayout.setImage(UIImage(named: "Selected"), for: .normal)
    }
    
    
}


