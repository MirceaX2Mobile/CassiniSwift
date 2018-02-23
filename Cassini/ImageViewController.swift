//
//  ImageViewController.swift
//  Cassini
//
//  Created by Dragota Mircea on 22/02/2018.
//  Copyright © 2018 Dragota Mircea. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var imageView = UIImageView()
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    // MARK: viewcontroller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  if imageURL == nil {
           // imageURL = DemoURLs.stanford
    //    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }

    // MARK: load image
    
    func fetchImage() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents , url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
            
            
        }
    }
    
    // MARK: scrollview delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
