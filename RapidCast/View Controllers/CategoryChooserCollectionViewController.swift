//
//  CategoryChooserCollectionViewController.swift
//  RapidCast
//
//  Created by Arjun Nayak on 8/6/15.
//  Copyright (c) 2015 Arjun Nayak. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryChooserCollectionViewController: UICollectionViewController {
    
    struct Category {
        var name : String
        var image : UIImage
        var isSelected : Bool
    }
    
    var doneButton : UIBarButtonItem?
    
    var chosenCategories : ChosenCategories = ChosenCategories() //REALM CLASS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //println("\(self.chosenCategories.categoriesToStore)")
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "segueToHomeScreen")
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.allowsMultipleSelection = true
        
        if let cvl = collectionViewLayout as? UICollectionViewFlowLayout {
            let widthOfCollectionView = cvl.collectionViewContentSize().width
            cvl.itemSize.width = widthOfCollectionView/2.1
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //write the chosenCategory realm object
        
        let realm = Realm()
        
        realm.write {
            realm.add(self.chosenCategories, update: false)
            var objs = realm.objects(ChosenCategories)
        }
        
    }
    
    func segueToHomeScreen() {
        self.performSegueWithIdentifier("RapidCast", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "RapidCast") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let rapidCastController : RapidCastViewController = navigationController.viewControllers[0] as! RapidCastViewController
            
            //rapidCastController.chosenCategories = self.chosenCategories //send realm object to rapid cast controller
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return categories.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var category = categories[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCollectionViewCell

        if(category.isSelected) {
            cell.alpha = 0.5
        }
        else {
            //cell.alpha = 1
        }

        cell.categoryName.text = category.name
        cell.categoryImage.image = category.image
        
        return cell
    }

    
    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var category = categories[indexPath.row]
        
        var rCategory = RealmCategory()
        rCategory.value = category.name
        if(self.chosenCategories.categoriesToStore.indexOf(rCategory) == nil) { //if category is NOT in array
            self.chosenCategories.categoriesToStore.append(rCategory)
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.alpha = 0.5
        categories[indexPath.row].isSelected = true
        
        self.navigationItem.rightBarButtonItem = doneButton
        
        println("adding: \(self.chosenCategories.categoriesToStore)")
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let category = categories[indexPath.row]
        
        var rCategory = RealmCategory()
        rCategory.value = category.name
        var found = false
        var index = -1
        for(var i = 0; i < self.chosenCategories.categoriesToStore.count; i++) {
            if(rCategory.value == self.chosenCategories.categoriesToStore[i].value) {
                found = true
                index = i
            }
        }
        if(index != -1) {
            self.chosenCategories.categoriesToStore.removeAtIndex(index)
            println("removing: \(self.chosenCategories.categoriesToStore)")
        }

        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.alpha = 1
        categories[indexPath.row].isSelected = false
        
        if(self.chosenCategories.categoriesToStore.count == 0) {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK: Category list
    
    var categories : [Category] = [Category(name: "Arts", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Comedy", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Education", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Kids & Family", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Health", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "TV & Film", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Music", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "News & Politics", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Science & Medicine", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Sports & Recreation", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Technology", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Business", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Games & Hobbies", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Society & Culture", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false),
        Category(name: "Government", image: UIImage(named: "podcast icon.jpeg")!, isSelected: false)]

}
