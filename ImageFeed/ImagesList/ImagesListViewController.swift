//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 02.06.2023.
//
import UIKit

class ImagesListViewController: UIViewController {
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet weak private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        if let image = UIImage(named: "\(indexPath.row)") {
            cell.cellImage.image = image
        } else {
            return
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = UIImage(named: "like_button_on")
        } else {
            cell.likeButton.imageView?.image = UIImage(named: "like_button_off")
        }
    }
}
    extension ImagesListViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return photosName.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1
            
            guard let imageListCell = cell as? ImagesListCell else { // 2
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            configCell(for: imageListCell, with: indexPath) // 3
            
            return imageListCell // 4
        }
    }
    
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
