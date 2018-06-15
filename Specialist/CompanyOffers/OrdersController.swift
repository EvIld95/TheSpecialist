//
//  OrdersController.swift
//  Specialist
//


import Foundation

import UIKit
import Firebase

class OrdersController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(createOrder))
        
        collectionView?.backgroundColor = .white
        collectionView?.register(OrdersCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
        fetchAllOrders()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
        fetchAllOrders()
    }
    
    @objc func handleRefresh() {
        print("Handling refresh..")
        orders.removeAll()
        self.collectionView?.reloadData()
        fetchAllOrders()
    }
    
    @objc func createOrder() {
        let addOrderController = AddOrderController()
        let navController = UINavigationController(rootViewController: addOrderController)
        self.present(navController, animated: true, completion: nil)
    }
    
    fileprivate func fetchOrders() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchOrderWithUser(user: user)
        }
    }

    fileprivate func fetchOrderWithUser(user: User) {
        let ref = Database.database().reference().child("orders").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Order(user: user, dictionary: dictionary)
                post.id = key
                self.orders.append(post)
            })
            self.orders.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch orders:", err)
        }
    }
    
    fileprivate func fetchAllOrders() {
        Database.database().reference().child("orders").observeSingleEvent(of: .value) { (snapshot) in
            guard let orderIdsDictionary = snapshot.value as? [String: Any] else { return }
            let myGroup = DispatchGroup()
            orderIdsDictionary.forEach({ (key, value) in
                myGroup.enter()
                guard let ordersDictionary = value as? [String: Any] else { return }
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    ordersDictionary.forEach({ (orderKey, orderValue) in
                        guard let orderData = orderValue as? [String: Any] else { return }
                        var order = Order(user: user, dictionary: orderData)
                        order.id = orderKey
                        self.orders.append(order)
                    })
                    myGroup.leave()
                })
            })
            myGroup.notify(queue: .main) {
                self.orders.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView?.refreshControl?.endRefreshing()
                self.collectionView?.reloadData()
            }
            
        }
    }
    
    var orders = [Order]()
    
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
        var height: CGFloat = 180//username userprofileimageview
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrdersCell
        cell.order = orders[indexPath.item]
        return cell
    }
    
    
}
