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
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate{
    
    //MARK: - properties

    @IBOutlet weak var tableView: UITableView!
    let myrefreshcontrol = UIRefreshControl()
    var numberofpost = 20
    var posts = [PFObject]()
    let commentBar = MessageInputBar()
    var showcommetBar = false
    var currentPost: PFObject!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        myrefreshcontrol.addTarget(self, action: #selector(viewDidAppear), for: .valueChanged)
        self.tableView.refreshControl = myrefreshcontrol
        tableView.delegate = self
        tableView.dataSource = self
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"]) // due to new update to ios
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardHide(note:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardHide(note: NotificationCenter){
        commentBar.inputTextView.text = nil // clear input bar
        showcommetBar = false
        becomeFirstResponder()
    }
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    override var canBecomeFirstResponder: Bool{
        return showcommetBar // value will change from true or false depending users interactions 
    }
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author","comments","comments.author"])
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
        query.includeKeys(["author","comments","comments.author"])
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
        if(indexPath.section+1 == posts.count){
            loadmorePost()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]  // post from section
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2 // two one for post and one for add comment
 
    }
    func numberOfSections(in tableView: UITableView) -> Int {
         return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]  // post from section
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"PostCell") as! PostTableViewCell
            let user = post["author"] as! PFUser
            cell.nameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let imageurl  = imageFile.url!
            let url = URL(string: imageurl)!
            
            cell.postImageView.af_setImage(withURL: url)
            return cell
        }
        else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as! CommentsCell
            let postcomments = comments[indexPath.row-1]
            cell.commentLabel.text = postcomments["text"] as? String
            
            let user = postcomments["author"] as! PFUser
            cell.nameLabel.text = user.username
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
    }
 }
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier:"LoginViewController")
         // since window is in App delegate we need a way to get to it
        // we as casting as AppDelegate 
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // when user clicks on post
        let post = posts[indexPath.section]  // the post user selected
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count+1{
            showcommetBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            currentPost = post
        }
        

    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) { // when i press post
        let comment = PFObject(className: "Comments")
        let user = PFUser.current()!
        
        comment["text"] = text
        comment["author"] = user
        comment["post"] = currentPost
         
        currentPost.add(comment, forKey: "comments")
        currentPost.saveInBackground { (success, error) in
            if success {
                print("Success posting comment")
            }
            else {
                print ("Error posting comment:  \(error.debugDescription)")
            }
        }
         commentBar.inputTextView.text = nil
         showcommetBar = false
         becomeFirstResponder()
         commentBar.inputTextView.resignFirstResponder()
         tableView.reloadData()
          
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
