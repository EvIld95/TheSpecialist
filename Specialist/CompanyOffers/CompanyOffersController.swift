//
//  CompanyOffersController.swift
//  Specialist
//

import UIKit
import Firebase

class CompanyOffersController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var fetchedPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.tintColor = .white
        collectionView?.backgroundColor = .white
        collectionView?.register(CompanyOffersCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(createOffer))
        
        setupNavigationItems()
        fetchAllOffers()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh..")
        posts.removeAll()
        self.collectionView?.reloadData()
        fetchAllOffers()
    }
    
    @objc func createOffer() {
        let addCompanyOfferController = AddCompanyOfferController()
        //let layout = UICollectionViewFlowLayout()
        //let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: addCompanyOfferController)
        
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func fetchAllOffers() {
        Database.database().reference().child("offers").observeSingleEvent(of: .value) { (snapshot) in
            guard let orderIdsDictionary = snapshot.value as? [String: Any] else { return }
            let myGroup = DispatchGroup()
            orderIdsDictionary.forEach({ (key, value) in
                myGroup.enter()
                guard let ordersDictionary = value as? [String: Any] else { return }
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    ordersDictionary.forEach({ (orderKey, orderValue) in
                        guard let orderData = orderValue as? [String: Any] else { return }
                        var post = Post(user: user, dictionary: orderData)
                        post.id = orderKey
                        self.posts.append(post)
                    })
                    myGroup.leave()
                })
            })
            myGroup.notify(queue: .main) {
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView?.refreshControl?.endRefreshing()
                self.collectionView?.reloadData()
            }
            
        }
    }
    

    var posts = [Post]()
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("offers").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
            
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                self.posts.append(post)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    func setupNavigationItems() {
        let logoText = UILabel()
        logoText.text = "The Specialist"
        logoText.font = UIFont.boldSystemFont(ofSize: 30)
        logoText.numberOfLines = 0
        logoText.textAlignment = .center
        logoText.textColor = .white
        
        navigationItem.titleView = logoText
        navigationController?.navigationBar.barTintColor = .specialistBlue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 90
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CompanyOffersCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailCompanyOffer = DetailCompanyOffer()
        detailCompanyOffer.post = posts[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! CompanyOffersCell
        detailCompanyOffer.image = cell.photoImageView.image
        detailCompanyOffer.profileImage = cell.userProfileImageView.image
        navigationController?.pushViewController(detailCompanyOffer, animated: true)
    }
    
    
}

