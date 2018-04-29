//
//  ViewController.swift
//  Dogs
//
//  Created by Raman Singh on 2018-04-28.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    
    
    var allDogs = [AnyObject]();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
    }//load
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDogs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DogCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)  as? DogCell)!
        
    var thisDog = Dog()
        thisDog = allDogs[indexPath.row] as! Dog
        cell.imageView.image = thisDog.image
     return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func loadJson() {
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=df067bfc5c1fcc1d784b40d2751e0355&tags=dog"
        
        let url = NSURL(string: urlString)
        let urlRequest = URLRequest(url: url! as URL)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: urlRequest, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
            
            //            if let response = response {
            ////                print(response)
            //            }
            //            if let error = error {
            ////                print(error)
            //            }
            
            if let allPhotos = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as! Dictionary<String, Any>
            {
                if let photosDict = allPhotos["photos"] as? Dictionary<String, AnyObject> {
                    let photoArray = photosDict["photo"] as! NSArray
                    for currentDict in photoArray {
                        if currentDict is Dictionary<String, AnyObject> {
                            if let thisDict = currentDict as? Dictionary<String, AnyObject> {
                            let thisDog = Dog()
                            thisDog.farm = thisDict["farm"] as! Int
                            thisDog.photoID = thisDict["id"] as! String
                            thisDog.isfamily = thisDict["isfamily"] as! Int
                            thisDog.isfriend = thisDict["isfriend"] as! Int
                            thisDog.ispublic = thisDict["ispublic"] as! Int
                            thisDog.owner = thisDict["owner"] as! String
                            thisDog.secret = thisDict["secret"] as! String
                            thisDog.server = thisDict["server"] as! String
                            thisDog.title = thisDict["title"] as! String
                            thisDog.photoURL = thisDog.makeURL()!
                            self.allDogs.append(thisDog)
                            self.makeImageFromUrl(dogURL: thisDog.photoURL, dog: thisDog)
                        }//thisDict
                        }//forLoop
                    }//photoArray[0]
                }//ifletPhotoDict
            }//if let allPhotos
        })
        task.resume()
        
    }//loadJson
    
    
    func makeImageFromUrl(dogURL:String, dog:Dog) {
        
        let url = NSURL(string:dogURL)
        let urlRequest = URLRequest(url: url! as URL)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
        
            if (error != nil)  {
                print(error as Any)
            } else {
                OperationQueue.main.addOperation {
                    if let bach = UIImage(data: data!) {
//                        self.imageView.image = bach
                        dog.image = bach
                        
                        self.collectionView.reloadData()
                    }
                }
                
                
            }//else
            })
    
        task.resume()
        
    }//makeImageFromUrl
    
    
    
    
    
    
    
    
    
    
    
}//end



