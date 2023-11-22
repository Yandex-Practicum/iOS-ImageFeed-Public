//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 19.11.2023.
//

import UIKit
import Kingfisher

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    private (set) var avatar: UIImageView = UIImageView()
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/users/\(username)?client_id=\(accessKey)")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "")", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    let avatarURLPath = userResult.profileImage.large.absoluteString
                    let avatarURL = URL(string: avatarURLPath)!
                    self?.avatar.kf.indicatorType = .activity
                    self?.avatar.kf.setImage(with: avatarURL,
                                            placeholder: UIImage(named: "placeholder"),
                                            options: [.processor(RoundCornerImageProcessor(radius: Radius.heightFraction(0.5))),
                                                      .scaleFactor(UIScreen.main.scale),
                                                      .cacheOriginalImage]) { result in
                                                          switch result {
                                                          case .success(_):
                                                              NotificationCenter.default
                                                                  .post(
                                                                    name: ProfileImageService.didChangeNotification,
                                                                    object: self,
                                                                    userInfo: ["URL": userResult.profileImage.large.absoluteString])
                                                          case .failure(let error):
                                                              print(error)
                                                          }
                                                      }
                    completion(.success(avatarURLPath))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: URL
        let medium: URL
        let large: URL
        
        enum CodingKeys: String, CodingKey {
            case small
            case medium
            case large
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

enum ProfileImageError: Error {
    case invalidURL
    case noData
}
