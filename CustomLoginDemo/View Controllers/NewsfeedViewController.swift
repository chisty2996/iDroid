//
//  NewsfeedViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 18/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseUI


class newsfeedcell:UITableViewCell{
    @IBOutlet weak var phonemodelLabel: UILabel!
    
    @IBOutlet weak var phonepartsLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet var divisionLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBAction func callButtonTapped() {
        actionBlock?()
    }
    @IBOutlet var callButton: UIButton!
    var actionBlock: (()-> Void)? = nil;
   
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var cameraButton: UIButton!
   /* override func awakeFromNib() {
        super.awakeFromNib()
        self.callButton.addTarget(self, action: #selector(callButtonTapped(_:)), for: .touchUpInside)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func callNumber(phoneNumber:String) {
        /*if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                    return;
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    return;
                    
                }
            }
        }
        else{
            return;
        }*/
        print("fuck x");
    }*/
}

class posts{
    var phoneModel: String?
    var phoneParts: String?
    var price: String?
    var contact: String?
    var division: String?
    var uid: String?
    //var photo: UIImage?
    var photourl:String?
    init(phoneModel :String? , phoneParts: String?, price: String?, contact: String?,uid: String?,division: String?,photourl:String?){
        self.uid = uid;
        self.phoneModel = phoneModel
        self.phoneParts = phoneParts
        self.price = price
        self.contact = contact
        self.division = division
        self.photourl = photourl;
    }
}
class Myposts{
    var postx:posts?
    var image:UIImage?
    init(postx: posts?,image:UIImage?) {
        self.postx = postx;
        self.image = image;
    }
    func contains_val(name:String)->Bool{
        if((self.postx?.phoneModel?.lowercased().contains(name))! ||  (self.postx?.phoneParts?.lowercased().contains(name))! || (self.postx?.division?.lowercased().contains(name))! || self.postx?.price?.lowercased().contains(name) ?? false){
            return true;
        }
        return false;
    }
}

class NewsfeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet weak var productView: UITableView!
    var storage = Storage.storage();
    var ref = Firestore.firestore()
    var postList = [Myposts]()
    var searching = false;
    var searchstr = [String]()
    var filteredPost = Array<Myposts>()
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("postcount",postList.count)
        if(searching){
            return filteredPost.count
        }
        else{
            return postList.count
        }}
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0){
            searching = false;
            productView.reloadData();
        }
        else{
            filteredPost = postList.filter({
                $0.contains_val(name: searchText.lowercased())
            })
            searching = true;
            productView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false;
        searchBar.text = "";
        productView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "MyCell" , for: indexPath) as! newsfeedcell
        var test:Myposts;
        if(searching){
            test = filteredPost[indexPath.row]
        }
        else{
            test = postList[indexPath.row]
        }
        // print(test.photourl)
        cell.phonemodelLabel?.text = test.postx?.phoneModel
        cell.phonepartsLabel?.text = test.postx?.phoneParts
        cell.priceLabel?.text = test.postx?.price
        cell.contactLabel?.text = test.postx?.contact
        cell.divisionLabel?.text = test.postx?.division
        cell.photo?.image = test.image
        cell.actionBlock = {
            print("NICE CELL");
            self.callNumber(phoneNumber: test.postx!.contact!)
        }
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        productView.dataSource = self
        productView.delegate = self
        searchBar.delegate = self
        DispatchQueue.main.async {
            self.LoadCalls()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10) {
            self.productView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+20) {
            self.productView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    
    @IBAction func update2(_ sender: Any) {
        print("hello i am 2nd one")
    }
    @IBAction func update(_ sender: Any) {
        print("hellooooo")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.productView.reloadData()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
    }
    
    func LoadCalls()
    {
        ref = Firestore.firestore();
        let userID = Auth.auth().currentUser?.uid
        print(userID)
        ref.collection("posts").getDocuments() {
            (querySnapshot,err) in if let err = err{
                print("Error ",err);
            }
            else{
                self.postList.removeAll();
                //  self.imagex = Array<UIImage>();
                for document in querySnapshot!.documents{
                    let model = document.data()["phonemodel"]
                    let parts = document.data()["phoneparts"]
                    let price = document.data()["price"]
                    let contact = document.data()["contact"]
                    let posterID = document.data()["uid"]
                    let region = document.data() ["division"]
                    let photourl = document.data()["postImageUrl"]
                    let myposts = posts( phoneModel: model as!String? ,phoneParts: parts as! String?, price: price as! String?, contact: contact as! String?,uid: posterID as! String?,division: region as! String?,photourl: photourl as! String?)
                    let ref = Storage.storage().reference();
                    let fref = ref.child(myposts.photourl!);
                    fref.getData(maxSize: 1*1024*1024) { (data, error) in
                        if(error == nil){
                            //  self.imagex.append(UIImage(data: data!)!);
                            let tmp = Myposts(postx: myposts, image: UIImage(data: data!))
                            self.postList.append(tmp)
                        }
                        else{
                            print(error);
                        }
                    }
                    
                }
            }
            
        }
        
        /*ref.child("posts").queryOrdered(byChild: userID).queryEqual(toValue: userID!).observe(.childAdded, with: { (snapshot) in
         let results = snapshot.value as? [String : AnyObject]
         let model = results?["phonemodel"]
         let parts = results?["phoneparts"]
         
         let price = results?["price"]
         let contact = results?["contact"]
         let docRef = db.collection("cities").document("SF")
         
         // Force the SDK to fetch the document from the cache. Could also specify
         // FirestoreSource.server or FirestoreSource.default.
         docRef.getDocument(source: .cache) { (document, error) in
         if let document = document {
         let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
         print("Cached document data: \(dataDescription)")
         } else {
         print("Document does not exist in cache")
         }
         }
         
         let myposts = posts( phoneModel: model as!String? ,phoneParts: parts as! String?, price: price as! String?, contact: contact as! String?)
         self.postList.append(myposts)
         print(myposts)
         DispatchQueue.main.async {
         print("came")
         self.productView.reloadData()
         }
         })*/
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
