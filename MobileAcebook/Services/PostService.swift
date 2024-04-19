////
////  PostService.swift
////  MobileAcebook
////
////  Created by Bogdan Stăiculescu on 17/04/2024.
////
//
//import Foundation
//
//class postService {
//    
//    // response returned on succesful /POST request
//    struct Response: Codable {
//        // let message : String
//        let token: String
//    }
//    
//    
//    func createPost(post: Post, token: String, completion: @escaping ((String) -> Void)) -> Bool {
//        // defining URL to which we make the POST on the Backend
//        guard let url = URL(string: "http://localhost:3000/posts") else
//        {return false}
//        
//        // var that contains the URL request and content
//        var urlRequest = URLRequest(url: url)
//        // method of the createPost
//        urlRequest.httpMethod = "POST"
//        // value of the URL request that's being sent to backend [application/json]
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        // also passing along Bearer and Token to show authorization
//        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        
//        // defining the body of the HTTP request
//        let body = post
//        
//        urlRequest.httpBody = try? JSONEncoder().encode(body)
//        
//        // defining what we do with the response of our request
//        let task = URLSession.shared.dataTask(with: urlRequest) {data, response, error in
//            // ensures there is data that returns after making the request ELSE print error
//            guard let data = data else {return}
//            // if there is data
//            do {
//                let response = try JSONDecoder().decode(Response.self, from: data)
//                //print(response.token)
//                DispatchQueue.main.async {
//                    completion(response.token)
//                }
//                print("Post Created")
//            }
//            catch {
//                print(error)
//            }
//        }
//        task.resume()
//        return true
//    }
//}


import Foundation

public struct post: Codable {
    let _id: String
    let message: String
    let createdAt: String
    let imgUrl: String?
    let likes: [String]
    let createdBy: String
}


class PostService {
    // Response returned on successful PUT request
    struct Response: Codable {
        let _id: String
        let message: String
        let createdAt: String
        let createdBy: String
        let imgUrl: String?
        var likes: [String]
        let token: String
        
        private enum CodingKeys: String, CodingKey {
            case _id
            case message
            case createdAt
            case createdBy
            case imgUrl
            case likes
            case token
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self._id = try container.decode(String.self, forKey: ._id)
            self.message = try container.decode(String.self, forKey: .message)
            self.createdAt = try container.decode(String.self, forKey: .createdAt)
            self.createdBy = try container.decode(String.self, forKey: .createdBy)
            self.imgUrl = try container.decodeIfPresent(String.self, forKey: .imgUrl)
            self.likes = try container.decode([String].self, forKey: .likes)
            self.token = try container.decode(String.self, forKey: .token)
        }
    }
    
    func likePost(postID: String, token: String, completion: @escaping ((post, String) -> Void)) {
        guard let url = URL(string: "http://localhost:3000/posts/\(postID)/like") else {
            completion(post(_id: "", message: "", createdAt: "", imgUrl: "", likes: [], createdBy: ""), "")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(post(_id: "", message: "", createdAt: "", imgUrl: "", likes: [], createdBy: ""), "")
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    let post = post(_id: response._id, message: response.message, createdAt: response.createdAt, imgUrl: response.imgUrl, likes: response.likes, createdBy: response.createdBy)
                    completion(post, response.token)
                }
            } catch {
                print(error)
                completion(post(_id: "", message: "", createdAt: "", imgUrl: "", likes: [], createdBy: ""), "")
            }
        }
        task.resume()
    }
}

// Usage
let postService = PostService()
let tempToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjYxZDEwZDQ5YzUwZWEwNmRiMTc2MmM2IiwiaWF0IjoxNzEzNTM2NDUwLCJleHAiOjE3MTM1MzcwNTB9.0xZrpcSUP28Mmy5P94WD6uqWZHDcDXNAWvRWbzvLls0"

func performLikePost() {
    postService.likePost(postID: "661d11669c50ea06db1762c8", token: tempToken) { post, token in
        if !post._id.isEmpty {
            print("Post ID: \(post._id)")
            print("Message: \(post.message)")
            print("Created At: \(post.createdAt)")
            print("Created By: \(post.createdBy)")
            print("Likes: \(post.likes)")
        } else {
            print("Failed to like the post.")
        }
        print("Token: \(token)")
    }
}

//performLikePost()
