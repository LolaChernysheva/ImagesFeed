//
//  AuthConfiguration.swift
//  ImagesFeed
//
//  Created by Lolita Chernysheva on 14.12.2023.
//  
//

import Foundation

struct AuthConfiguration {
    static let accessKey = "q8nYV0KRlCc-QSOzVFjbhGqgYCb9o-Jz3sLHTSfNEoQ"
    static let secretKey = "k6PQqnRysz0-Jd0zFAJBdXyXxD4sQHlWp0fLdvM2YGo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let appId = "540804"
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
}
