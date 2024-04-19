//
//  FeedPageView.swift
//  MobileAcebook
//
//  Created by Jess Todd on 18/04/2024.
//

import Foundation
import SwiftUI

struct FeedPageView: View {
    let token: String // Property to hold the token
    init(token: String) {
    self.token = token // Initialize the token property
    }
    @State private var text = ""
//    @State public var token: String
    @ObservedObject public var posts = FeedService()
    var testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjYxZDEwZDQ5YzUwZWEwNmRiMTc2MmM2IiwiaWF0IjoxNzEzNTI3MDE2LCJleHAiOjE3MTM1Mjc2MTZ9.AurZtQnDoRFKfbMhK2JUHHpj3PraNkWu1ISgs84HHN0"
    
    var body: some View {
        
        VStack {
            
            Text("Pawbook")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.50, green: 0.71, blue: 0.71))
                .foregroundColor(.white)
            
            Text("Your feed")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.top, 20)
            
            TextField("Type something...", text: $text)
                .padding(.vertical, 20)
                .padding(.horizontal)
                .font(.system(size: 18))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(10)
                .padding([.leading, .trailing], 24)
            
            Button("Add Post"){
                
            }
            .frame(width: 250, height: 40)
            .background(Color(red: 0x50/255, green: 0xB7/255, blue: 0xB7/255))
            .foregroundColor(.white)
            .cornerRadius(10)
        Spacer()
            
            Text("Hello")
            
            VStack {
                List(posts.postsData, id: \._id) { post in
                    Section(header: Text("Posted by \(post.createdBy.username)")) {
                        Text(post.message ?? "No message available")
                            .padding()
                        // Optionally display image, likes, etc.
                    }
                }
            }

        }
        .onAppear {
            print("fetching")
            posts.getPost(token: testToken){fetchedPost in
                self.posts.postsData = fetchedPost.posts}
            print("fetching2")
            print(token)
        }
    }
}
    
    
    struct FeedPageView_Previews: PreviewProvider {
        static var previews: some View {
            FeedPageView(token: "")
            }
        }

