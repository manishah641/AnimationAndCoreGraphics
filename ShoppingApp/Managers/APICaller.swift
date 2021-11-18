//
//  APICaller.swift
//  ShoppingApp
//
//  Created by syed on 11/10/2021.
//

import Foundation
enum APiError :Error {
    case failedToGetData
}
 final class APICaller {
 
    
    static let shared = APICaller()
 
      let url = "https://worldwide-restaurants.p.rapidapi.com/search"
    
    public func getData(completion:@escaping (Result<[Resturant],Error>)-> Void){
        /*createRequest { request in
            let task = URLSession.shared.dataTask(with: request) { data, responce, error in
                guard let data = data else  {
                    completion(.failure(APiError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(APIResponce.self, from: data)
                    print(result)
                  //  let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                   //print("Json is : \(json)")
                }catch {
                    print("error is: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            }
            task.resume()*/
            guard let pathString = Bundle(for: type(of: self)).path(forResource: "data", ofType: "json") else {
                fatalError("UnitTestData.json not found")
            }

            guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
                fatalError("Unable to convert UnitTestData.json to String")
            }

            print("The JSON string is: \(jsonString)")

            guard let jsonData = jsonString.data(using: .utf8) else {
                fatalError("Unable to convert UnitTestData.json to Data")
            }
            

            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] else {
                fatalError("Unable to convert UnitTestData.json to JSON dictionary")
            }

            print("The JSON dictionary is: \(jsonDictionary)")
     
        
    }
     enum HTTPMethod :String {
         case GET
         case POST
         case DELETE
         case PUT
         
     }
     private func createRequest( comletion:@escaping(URLRequest)-> Void){
     

         let headers = [
             "content-type": "application/x-www-form-urlencoded",
             "x-rapidapi-host": "worldwide-restaurants.p.rapidapi.com",
             "x-rapidapi-key": "acf0dd9a9amsh1d39ad519442ddfp11ee9ejsn1fd48b2b91aa"
         ]

         let postData = NSMutableData(data: "currency=USD".data(using: String.Encoding.utf8)!)
         postData.append("&language=en_US".data(using: String.Encoding.utf8)!)
         postData.append("&location_id=15333482".data(using: String.Encoding.utf8)!)
         postData.append("&limit=15".data(using: String.Encoding.utf8)!)

         let request = NSMutableURLRequest(url: NSURL(string: "https://worldwide-restaurants.p.rapidapi.com/photos")! as URL,
                                                 cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 10.0)
         request.httpMethod = "POST"
         request.allHTTPHeaderFields = headers
         request.httpBody = postData as Data

        comletion(request as URLRequest)
         print(request)
            
        }
        
        
     

  

}
