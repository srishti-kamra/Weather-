import SwiftUI

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        NavigationView {
            List(results) { item in
                VStack(alignment: .leading) {
                    Link(destination: URL(string: item.trackViewUrl)!){
                        Text(item.trackName)
                            .font(.headline)
                    }
                    Text(item.collectionNames)
                }
            }
                    .navigationTitle("Katy Perry Songs!")
                    
                }
                .task {
                    await loadData()
                }
            
        }
        
        func loadData() async {
            if let url = URL(string:"https://itunes.apple.com/search?term=katy+perry&entity=song") {
                if let (data, _) = try? await URLSession.shared.data(from: url) {
                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                        results = decodedResponse.results
                    }
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct Result: Identifiable, Codable {
        var id = UUID()
        var trackID: Int
        var trackName: String
        var collectionNames: String
        var trackViewUrl: String
        
        enum CodingKeys: String, CodingKey {
            case trackId
            case trackName
            case collectionNames
            case trackViewUrl
            
        }
    }


struct Response: Codable {
    var results: [Result]
    
}

