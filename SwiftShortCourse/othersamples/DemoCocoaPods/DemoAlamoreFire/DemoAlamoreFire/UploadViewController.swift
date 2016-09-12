//
//  UploadViewController.swift
//  DemoAlamoreFire
//
//  Created by Vinh The on 8/31/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController{
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var imageNameTextField: UITextField!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        progressLabel.hidden = true
        progressBar.hidden = true
        
        navigationItem.rightBarButtonItem = getPhotoBarButton()
        imagePicker.delegate = self
    }
    
    
    @IBAction func uploadImageAction(sender: AnyObject) {
        
        guard let imageForUpload = myImageView.image else {return}
        
        if imageNameTextField.text != ""{
            uploadImageRequest(imageNameTextField.text!, image : imageForUpload, completionHandle: {
                self.progressBar.hidden = true
                self.progressLabel.hidden = true
                self.uploadImageButton.hidden = false
                
                self.progressBar.progress = 0.0
                self.progressLabel.text = "0%"
            })
        }else{
            print("Bạn cần nhập đẩy đủ tên và chọn hình cần upload")
        }
    }
    
    func uploadImageRequest(imageName : String , image : UIImage, completionHandle : (()->Void)) {
        
        // Convert đối tượng UIImage thành đối tượng NSData.
        let imageData = UIImagePNGRepresentation(image)
        
        // Tạo parameters cần thiết theo yêu cầu của server-side.
        let param : [String : AnyObject] = ["name" : imageName,
                                            "photofile" : imageData!]
        
        // Nối thêm trường cần thiết cho request's header.
        
        header["Content-type"] = "multipart/form-data"
        
        //Request upload Image
        Alamofire.upload(.POST, IMAGE_URL + UPLOAD_IMAGE_API, headers: header, multipartFormData: { (multipartFormData) in
            //Nối part từ parameter vào body truyền tới server-side
            for (key , value) in param{
                if key == "name" { //kiểm tra key trong param - nếu value là string thì encoding và nối vào body request.
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                
                if key == "photofile"{//kiểm tra key trong param - nếu value là Data thì tùy từng trường hợp theo yêu cầu từ server-side mà config. trường hợp này chúng ta gởi lên file binary là 1 image cần đầy đủ các thông tin như filename và mimeType
                    multipartFormData.appendBodyPart(data: value as! NSData, name: key, fileName: "photofile.png", mimeType: "image/png")
                }
            }
            
        }) { (encodingResult) in //closure trả về kết quả sau khi append và encoding body request
            //Success hoặc Failed
            switch encodingResult{
            case.Success(let requestUpload,_,_):
                //Theo dõi quá trình upload
                requestUpload.progress({ (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    let percent = (Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.configureProgressBar(percent)
                    })
                })
                //Lấy kết quả trả về cuối cùng từ server
                requestUpload.responseJSON(completionHandler: { (response) in
                    completionHandle()
                })
            case.Failure(let error):
                print(error)
            }
        }
    
    }
    
    func configureProgressBar(percent : Float) {
        progressLabel.hidden = false
        progressBar.hidden = false
        uploadImageButton.hidden = true
        
        progressBar.setProgress(percent, animated: true)
        progressLabel.text = String(format :"%.f %%", percent * 100)
    }
    
    func getPhotoBarButton() -> UIBarButtonItem {
        let libraryBarButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(getPhotoFromLibrary(_:)))
        
        return libraryBarButton
    }
    
    func getPhotoFromLibrary(sender : AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
}

extension UploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        myImageView.image = pickedImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
