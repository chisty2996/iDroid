//
//  PostViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 18/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation

class PostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet var tapgesture: UITapGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phonemodelTextField: UITextField!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet var divisionTextField: UITextField!
    @IBOutlet weak var phonepartsTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    var pickerData = ["Dhaka","Sylhet","Chittagong","Khulna","Rajshahi","Barisal","Rangpur","Mymensingh"]
    var takenImage: UIImage!
    let imagePicker = UIImagePickerController()
    var thePicker = UIPickerView()
    var picurl:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        divisionTextField.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
        imagePicker.delegate = self
        setUpElements()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        divisionTextField.text = pickerData[row]
        self.view.endEditing(true)
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(phonemodelTextField)
        
        Utilities.styleTextField(phonepartsTextField)
        
        Utilities.styleTextField(priceTextField)
        
        Utilities.styleTextField(contactTextField)
        
        Utilities.styleFilledButton(postButton)
        Utilities.styleTextField(divisionTextField)
    }
    
    @IBAction func keyboardhide(_ sender: Any) {
        print("hide")
        self.view.endEditing(true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        self.takenImage = image
        self.imageView.image = self.takenImage
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func validatefields() -> String?
    {
        if (phonemodelTextField.text?.isEmpty)! || (phonepartsTextField.text?.isEmpty)! || (priceTextField.text?.isEmpty)! || (contactTextField.text?.isEmpty)!
            || (divisionTextField.text?.isEmpty)!
            
        {
            return "Please fill in all fields."
        }
        return nil
        
    }
    
    func returnDistanceTime(distanceTime: TimeInterval) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: NSDate() as Date)
    }
    
    
    func getCreationTimeInt(dateString : String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        let time = dateFormatter.date(from: dateString)?.timeIntervalSince1970
        
        let distanceTime = NSDate().timeIntervalSince1970 - time!
        
        let stringTime = returnDistanceTime(distanceTime: distanceTime)
        
        print("**** The time \(stringTime)", terminator: "")
        
        return stringTime
        
    }
    
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        
        if (phonemodelTextField.text?.isEmpty)! || (phonepartsTextField.text?.isEmpty)! || (priceTextField.text?.isEmpty)! || (contactTextField.text?.isEmpty)!
            || (divisionTextField.text?.isEmpty)!
            
        {
            showError("Please fill in all fields")
        }
        else{
        
        let uid = Auth.auth().currentUser?.uid
        let id = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("postimage/" + id + ".png")
        let nowimage = resize(self.imageView.image!);
        if let uploadData = nowimage.pngData(){
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                if err != nil {
                    self.showError("something went wrong")
                }
                
            }
            
        }
        
        
        self.picurl = "postimage/" + id + ".png"
        print("Camw"+self.picurl)
        
        
        let phonemodel = phonemodelTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneparts = phonepartsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let price = priceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contact = contactTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let division = divisionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let db = Firestore.firestore()
        
        db.collection("posts").addDocument(data: ["phonemodel":phonemodel, "phoneparts":phoneparts, "price":price,"uid": uid!, "contact":contact,"division":division,"postImageUrl":picurl]
        ) { (err) in
            if err != nil{
                self.showError("Error Uploading post")
            }
            else{
                self.transitionToHome()
            }
        }
        }
            
        
    }
    
    func displayregAlertMessage(userMessage: String)
    {
        let myalert = UIAlertController(title: "Alert!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okaction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        
        
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker,animated: true,completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func transitionToHome()
    {
        let TabViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? UITabBarController
        
        view.window?.rootViewController = TabViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    
    
}


