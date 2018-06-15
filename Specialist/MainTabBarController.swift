//
//  MainTabBarController.swift
//  Specialist


import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        //companyOffers
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let offerimage = resizeImage(image: #imageLiteral(resourceName: "offer"), newWidth: 44)
        let companyOffersController = CompanyOffersController(collectionViewLayout: collectionViewFlowLayout)
        let homeNavController = templateNavController(unselectedImage: offerimage!, selectedImage: offerimage!, rootViewController: companyOffersController)

        
        let collectionViewFlowLayout2 = UICollectionViewFlowLayout()
        let orderimage = resizeImage(image: #imageLiteral(resourceName: "order"), newWidth: 40)
        let ordersController = OrdersController(collectionViewLayout: collectionViewFlowLayout2)
        let likeNavController = templateNavController(unselectedImage: orderimage!, selectedImage: orderimage!, rootViewController: ordersController)
        
        //user profile
        
        let mapViewController = MapViewController()
        
        let mapNavController = UINavigationController(rootViewController: mapViewController)
        
        let image = resizeImage(image: #imageLiteral(resourceName: "map"), newWidth: 40)
        mapNavController.tabBarItem.image = image
        mapNavController.tabBarItem.selectedImage = image
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           likeNavController,
                           mapNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}

