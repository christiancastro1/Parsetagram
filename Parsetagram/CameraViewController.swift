//
//  CameraViewController.swift
//  Parsetagram
//
//  Created by Christian Alexander Valle Castro on 11/16/19.
//  Copyright © 2019 valle.co. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Mark :: Properties
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onSubmit(_ sender: Any) {
       let post = PFObject(className: "Posts")  // dictionary of posts
       
        post["caption"] = captionField.text!
        post["author"]  = PFUser.current()!
        
        let imagedata = imageView.image!.pngData()
        let file = PFFileObject(data: imagedata!)
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success{
                self.dismiss(animated: true, completion: nil )
                print("Saved!")
            }
            else {
                print("Not saved")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){// if camera is available
            picker.sourceType = .camera
        }
        else{
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
    }
    
     
    @IBAction func hidekeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
