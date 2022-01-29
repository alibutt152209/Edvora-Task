//
//  ContentView.swift
//  Edvora Task
//
//  Created by Ali Butt on 29/01/2022.
//

import SwiftUI

struct ContentView: View {
    @State var products : [Products] = [ ]
    var body: some View {
        ZStack {
            NavigationView {
                List(products) { product in
                    Text(product.brand_name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    ScrollView (.horizontal) {
                        HStack {
                            VStack (alignment: .leading, spacing: 10) {
                                HStack (spacing: 10) {
                                    AsyncImage(url: URL(string: product.image))
                                        { image in
                                          image
                                            .resizable()
                                            .scaledToFit()
                                            .clipped()
                                            .frame(width: 100, height: 100)
                                        } placeholder: {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .clipped()
                                                .frame(width: 100, height: 100)
                                        }
                                    VStack (alignment: .leading, spacing: 10) {
                                        Text( product.product_name)
                                            .font(.headline)
                                            .foregroundColor(Color.white)
                                        Text(product.brand_name)
                                            .foregroundColor(Color.gray)
                                        Text("$ \(product.price)")
                                            .font(.headline)
                                            .foregroundColor(Color.white)
                                    }
                                }
                                HStack (spacing: 10) {
                                    Text("Location")
                                        .foregroundColor(Color.white)
                                    Text("Date: \(product.date)")
                                        .foregroundColor(Color.white)
                                }
                                Text(product.discription)
                                    .foregroundColor(Color.white)
                            }
                            .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                            
                        }
                        
                    }.padding(.all, 20.0).frame(height: 200.0).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                }
                .onAppear {
                        Api().getProducts { products in
                            self.products = products
                        }
                }
                .navigationBarTitle("Edvora")
                .alignmentGuide(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Guide@*/.leading/*@END_MENU_TOKEN@*/) { dimension in
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/dimension[.top]/*@END_MENU_TOKEN@*/
                }
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
            }
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.black/*@END_MENU_TOKEN@*/)
            
        }
    }
    
    struct Products: Codable, Identifiable {
        let id = UUID()
        
        
        let product_name : String
        let brand_name : String
        let price : Int
        let address : [String : String]
        let discription : String
        let date : String
        let time : String
        let image : String
    }

    class Api {
        func getProducts(completion : @escaping ([Products]) -> ()) {
            guard let url = URL(string: "https://assessment-edvora.herokuapp.com/") else {return}
            URLSession.shared.dataTask(with: url) { data, _, _ in
                let products = try! JSONDecoder().decode([Products].self, from: data!)
                DispatchQueue.main.async {
                    completion(products)
                }
            }
            .resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 {
 "product_name":"Raills India Limited",
 "brand_name":"Raills",
 "price":600,
 "address":{"state":"Tamil Nadu", "city":"Tirukalukundram"},
 "discription":"Its a good product",
 "date":"2016-06-09T22:41:12.101Z",
  "time":"2020-03-25T14:20:30.576Z",
 "image":"https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png"}
 */
