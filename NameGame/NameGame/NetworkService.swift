//
//  NetworkService.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/29/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var completeEndpoint: URL { get }
}

struct ProfilesApi: Endpoint {
    var baseUrl: String {
        return "https://willowtreeapps.com"
    }
    
    var path: String {
        return "/api/v1.0/profiles/"
    }
    
    var completeEndpoint: URL {
        guard let url: URL = URL(string: baseUrl + path) else { fatalError("Bad URL in profiles API") }
        return url
    }
}

class NetworkService {
    let profiles: ProfilesApi = ProfilesApi()

    // Return better errors!
    func getProfiles(completion: @escaping () -> Void) {
            let task = URLSession.shared.dataTask(with: profiles.completeEndpoint) { (data: Data?, resp: URLResponse?, error: Error?) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        do {
                            if let jsonArray: [Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any] {
                                let decoder = JSONDecoder()
                                for item in jsonArray {
                                    let data = try JSONSerialization.data(withJSONObject: item, options: [])
                                    let profile: Profile = try decoder.decode(Profile.self, from: data)
                                    ProfileService.instance().add(profile: profile)
                                }
                                completion()
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
    }
}
