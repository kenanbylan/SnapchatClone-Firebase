//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Kenan Baylan on 18.12.2022.
//

import UIKit
import ImageSlideshow



class SnapVC: UIViewController {

    @IBOutlet var snapTimeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray  = [KingfisherSource]() //içerisinde kingfisherSourceler olan bir array yaptık.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snap  = selectedSnap {
            
            
            snapTimeLabel.text = "Time left : \(snap.timeDifference) hour."
            
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString:imageUrl )!)
                
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            
            
            
            imageSlideShow.backgroundColor = UIColor.lightGray
            imageSlideShow.layer.cornerRadius = 20.0
            imageSlideShow.layer.borderColor = CGColor.init(red: 10, green: 10, blue: 10, alpha: 10)
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.white
            pageIndicator.tintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            
            imageSlideShow.contentScaleMode  = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(snapTimeLabel)
        }
        
    }
    

}
