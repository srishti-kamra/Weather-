struct ContentView: View {
    @State private var showingAlert = false
    @State private var facts = [String]()
    var body: some View {
        NavigationView {
            NavigationLink ("click here") {
                VStack{
                    Text("Intresting Cat Facts!!")
                        .font(.title)
                        .fontWeight(.bold)
                    Image("hi")
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .bottom)
                    
                    List(facts, id: \.self) { fact in
                        Text(fact)
                    }
                    .navigationTitle("Enjoy")
                    .toolbar {
                        
                        Button(action: {
                            Task {
                                await loadData()
                            }
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                    }
                }
                .task {
                    await loadData()
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Loading Error"),
                          message: Text("There is a problem loading the API categories"),
                          dismissButton: .default(Text("OK")))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pink)
            .opacity(0.5)
        }
    }
    
    func loadData() async {
        if let url = URL(string:"https://meowfacts.herokuapp.com/?count=20") {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Facts.self, from: data) {
                    facts = decodedResponse.facts
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

struct Facts: Identifiable, Codable {
    var id = UUID()
    var facts: [String]
    
    enum CodingKeys: String, CodingKey {
        case facts = "data"
    }
}
