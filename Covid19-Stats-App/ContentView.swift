//
//  ContentView.swift
//  Covid19-Stats-App
//
//  Created by Sydney Achinger on 5/13/20.
//  Copyright © 2020 Sydney Achinger. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State  var input: String = ""
    @State var agent_res: String = "..."
    @State var avatar_state: String = "Neutral"
    
    var body: some View {
        VStack {
            Text("Ask About COVID-19")
                .font(Font.system(size: 35, weight: .medium, design: .serif))
                .foregroundColor(.blue)
          
            TextField("Ask me a question about COVID-19 ...", text: $input, onCommit: {
                    self.avatar_state = "Thinking"
                    self.agent_res = "..."
                    self.querySubmitted()
                })
                .padding(10)
                .font(Font.system(size: 15, weight: .medium, design: .serif))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
            
            Image(avatar_state)
                .resizable()
                .scaledToFit()
                .frame(width: 325.0, height: 325.0)
                .rotationEffect(.degrees(20))
            
         
           if(agent_res != ""){
                Text(agent_res).fixedSize(horizontal: false, vertical: true)
                    .font(Font.system(size: 15, weight: .medium, design: .serif))
           }
        }
        .padding(.horizontal, 10.0)
        
    }
    
    
    func querySubmitted () {
        
        var query = self.input
        self.input = ""
        query = query.replacingOccurrences(of: "’", with: "")
        query = query.replacingOccurrences(of: " ", with: "%20")
        let endpoint = "https://warm-scrubland-53805.herokuapp.com/getIntent/" + query
        print(endpoint)
        
        guard let url = URL(string: endpoint) else {
          print("Error: cannot create URL")
          return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
               print("error calling GET on /todos/1")
               print(error!)
               return
             }
             // make sure we got data
             guard let responseData = data else {
               print("Error: did not receive data")
               return
             }
             // parse the result as JSON, since that's what the API provides
             do {
               guard let jsonData = try JSONSerialization.jsonObject(with: responseData, options: [])
                 as? [String: Any] else {
                 print("error trying to convert data to JSON")
                 return
               }
                guard let stringRes = jsonData["response"] as? String else {
                  print("Could not get response  from JSON")
                  return
                }
                print(stringRes)
                if(stringRes == ""){
                    self.agent_res = "I'm sorry, something went wrong."
                }
                else{
                    self.agent_res = stringRes
                }
                self.avatar_state = "Neutral"
             }catch{
                print("error trying to convert data to JSON")
                return
             }
          
        }
        task.resume()
    }
 
  
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
