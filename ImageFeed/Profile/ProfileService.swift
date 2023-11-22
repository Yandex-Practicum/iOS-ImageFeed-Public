//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Никита Гончаров on 19.11.2023.
//

import UIKit

final class ProfileService {
    
    static let shared = ProfileService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileProviderDidChange")
    private var profile: Profile?
    private var lastToken: String?
    private let lock = NSLock()
    private let semaphore = DispatchSemaphore(value: 0)
    
    func fetchProfile(_ token: String) {
        self.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.lock.unlock()
                self.semaphore.signal()
            case .failure(_ ):
                self.lastToken = nil
                self.lock.unlock()
                self.semaphore.signal()
            }
        }
    }
    
    func getProfile() -> Profile? {
        if self.profile == nil {
            self.semaphore.wait()
        }
        return self.profile
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        lock.lock()
        lastToken = token
        
        let url = URL(string: "https://api.unsplash.com/me")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) {  (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username, name: "\(profileResult.firstName) \(profileResult.lastName ?? "")", loginName: "@\(profileResult.username)", bio: profileResult.bio ?? "")
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
}
