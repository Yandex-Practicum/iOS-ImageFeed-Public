//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 11.11.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var fullImageUrl: String?
    
    // MARK: - IBOutlet

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    // MARK: - IBAction
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let shareButton = UIActivityViewController(activityItems: [image!], applicationActivities: [])
        present(shareButton, animated: true, completion: nil)
    }
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrl = fullImageUrl, let url = URL(string: imageUrl) {
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(with: url) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                
                guard let self = self else { return }
                switch result {
                case .success(let imageResult):
                    self.image = imageResult.image
                case .failure:
                    self.showError()
                }
            }
        }
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func showError() {
        let alertController = UIAlertController(title: "Error", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadFullImage()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func loadFullImage() {
        if let imageUrl = fullImageUrl, let url = URL(string: imageUrl) {
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(with: url) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                
                guard let self = self else { return }
                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                    self.showError()
                }
            }
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return imageView
    }
}
