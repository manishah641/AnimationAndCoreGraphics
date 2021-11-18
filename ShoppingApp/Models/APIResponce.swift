//
//  APIResponce.swift
//  ShoppingApp
//
//  Created by syed on 11/10/2021.
//

import Foundation
struct ApiImage:Codable {
    let url:String
    
}
struct APIResponce:Codable{
    let results :Resturant
    
}
struct Resturants:Codable {
    let data :[Resturant]
}
struct Resturant:Codable {
  //  let created_time: String
    //let images:[ApiImage]
    //let locations:Location
}
struct Location:Codable{
    let name:String
}
