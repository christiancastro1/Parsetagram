//
//  FeedViewController.swift
//  Parsetagram
//
//  Created by Christian Alexander Valle Castro on 11/16/19.
//  Copyright © 2019 valle.co. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //Mark:: properties

    @IBOutlet weak var tableView: UITableView!
    let myrefreshcontrol = UIRefreshControl()
    var numberofpost = 20
    
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myrefreshcontrol.addTarget(self, action: #selector(viewDidAppear), for: .valueChanged)
        self.tableView.refreshControl = myrefreshcontrol
        tableView.delegate = self
        tableView.dataSource = self
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = numberofpost
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.myrefreshcontrol.endRefreshing()
            }
            else{
                print("error finding post")
            }
        }

}
    func loadmorePost(){
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        numberofpost += 20
        query.limit = numberofpost
               
        query.findObjectsInBackground { (posts, error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.myrefreshcontrol.endRefreshing()
            }
            else{
                print("error finding post")
            }
        }
}
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row+1 == posts.count){
            loadmorePost()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PostCell") as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.nameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let imageurl  = imageFile.url!
        let url = URL(string: imageurl)!
        
        cell.postImageView.af_setImage(withURL: url)
        
 
        return cell
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
