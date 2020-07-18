//
//  ProfileViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 18/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
class userclass {
    var firstname:String;
    var lastname:String;
    var email:String;
    var uid:String;
    init(fname:String,lname:String,email:String,uid:String) {
        self.email = email;
        self.firstname = fname;
        self.lastname = lname;
        self.uid = uid;
    }
}

class imageclass {
    
    var imageDownloadURL: String
    var image:UIImage
    init(image: UIImage, imageDownloadURL:String)
    {
        self.image = image
        self.imageDownloadURL = imageDownloadURL
    }
}
class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var usernamelast: UILabel!
    @IBOutlet var usernamefirst: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var lastnameLabel: UILabel!
    @IBOutlet var firstnameLabel: UILabel!
    var takenImage: UIImage!
    let imagePicker = UIImagePickerController()
    var picurl:String = ""
    var ref = Firestore.firestore()
    var usernow = user(firstname: "", lastname: "", email: "", uid: "", propic: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        LoadCalls()
        errorLabel.alpha = 0
        usernamelast.alpha = 0
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        print("Camebuton");
        let uid = usernow.uid;
        let imageid = NSUUID().uuidString;
        let storageref = Storage.storage().reference().child("userimage/"+imageid+".png");
        let nowimage = resize(self.imageView.image!);
        if let uploadData = nowimage.pngData() {
            storageref.putData(uploadData,metadata: nil)  {(metadata,error ) in
                if error != nil {
                    self.showError(error!.localizedDescription);
                    return;
                }
                else{
                    print("after upload came")
                    self.picurl = "userimage/"+imageid+".png";
                    let ref = Firestore.firestore().collection("users").document(uid);
                    ref.updateData(["propic":self.picurl]) { (error) in
                        if error == nil {
                            print("done");
                            return;
                        }
                        else{
                            print("nothing");
                            print(error);
                            return;
                        }
                    }
                    self.displayMyAlertMessage(userMessage: "Uploaded Image Successfully!")
                }
            }
        }
        
        print("something",uid,imageid);
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        self.takenImage = image
        self.imageView.image = self.takenImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func displayMyAlertMessage(userMessage: String)
       {
           let myalert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
           let okaction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
           
           myalert.addAction(okaction)
           self.present(myalert, animated: true, completion: nil)
           
       }
    func displaylogoutMessage(userMessage: String)
    {
        let myalert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
    
        let yesaction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil)
        let noaction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {(myalert : UIAlertAction!) in self.transitionToHome1()})
        myalert.addAction(noaction)
        myalert.addAction(yesaction)
        self.present(myalert, animated: true, completion: nil)
        
    }
    
    func LoadCalls(){
        ref = Firestore.firestore();
        let userID = Auth.auth().currentUser?.uid
        var testnow = String(userID!);
        let x = ref.collection("users").document(testnow);
        x.getDocument { (document, error) in
            if let document = document, document.exists {
                self.usernow = user(firstname: document["firstname"] as! String, lastname: document["lastname"] as! String, email: document["email"] as! String, uid: document["uid"] as! String, propic: document["propic"] as! String)
                
                self.emailLabel.text = self.usernow.email;
                self.firstnameLabel.text = self.usernow.firstname;
                self.lastnameLabel.text = self.usernow.lastname;

                self.usernamelast.text = self.usernow.lastname
                self.usernamelast.alpha = 1
                let pref = Storage.storage().reference().child(self.usernow.propic);
                pref.getData(maxSize: 1*1024*1024) { (data, error) in
                    if(error == nil){
                        print("ok nice");
                        self.imageView.image = UIImage(data: data!)
                    }
                    else{
                        print("WTF");
                        print(error?.localizedDescription)
                    }
                }
                
            }
            
        }
    }
    
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return completion(nil)
        }
        
        // 2
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // 4
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
    static func create(for image: UIImage) {
        let imageRef = Storage.storage().reference().child("test_image.jpg")
        uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let id = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("userimage/" + uid! + ".png")
        let nowimage = resize(self.imageView.image!);
        if let uploadData = nowimage.pngData(){
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.showError("something went wrong")
                    return
                }
                else{
                    self.picurl = "userimage/" + id + ".png"
                    self.ref = Firestore.firestore();
                    let userID = Auth.auth().currentUser?.uid
                    let db = Firestore.firestore();
                    let ref = db.collection("users").document(userID!);
                    ref.updateData(["propic":self.picurl])
                    
                }
                self.transitionToHome();
            }
        }
        
    }
    
    func transitionToHome()
    {
        let TabViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? UITabBarController
        
        view.window?.rootViewController = TabViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToHome1()
    {
        let homeViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
               
               self.view.window?.rootViewController = homeViewController
               self.view.window?.makeKeyAndVisible()
    }
    /*
     self.ref.collection("users").getDocuments(){(querySnapshot,err) in if let
     err = err{
     print("Error",err);
     }
     else{
     print(userID);
     var testnow = String(userID!);
     for document in querySnapshot!.documents{
     
     var userid = document.data()["uid"]
     if(userid == nil){
     continue;
     }
     //var test = String(document.data()["uid"]);
     var testuser = String(userid as! String)
     print(testuser)
     if (testnow.elementsEqual(testuser))
     {
     let db = Firestore.firestore()
     
     /*  db.collection("users").addDocument(data: ["imageUrl": self.picurl] ) { (error) in
     if error != nil{
     self.showError("Error Uploading post")
     }
     }*/
     let ref = db.collection("users").document(self.usernow.uid);
     ref.updateData(["propic" : self.picurl])
     // ref.setData(["propic" : self.picurl],merge: true);
     
     }
     
     }
     }
     }
     */
    
    @IBAction func logoutTapped(_ sender: Any) {
        
       /* let homeViewController =  self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()*/
        displaylogoutMessage(userMessage: "Are You Sure?")
        
        
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
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
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

