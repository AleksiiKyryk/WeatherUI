//
//  ContentView.swift
//  WeatherApp
//
//  Created by Aleksii Kyryk on 15/08/2021.
//

import SwiftUI

struct ContentView: View{
    @State var cityName: String = MyLocations.mylocations[0].city
    @State private var darkMode = false;
    @State var isActive: Bool = false
    
    var body: some View{
        NavigationView{
            ZStack{
                BackgroundView(isNight: $darkMode)
                VStack{
                    WeatherView(cityWeather: cityName, isNight: $darkMode)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                    Spacer()
                    NavigationLink(
                        destination: LocationsView(shouldPopToRootView: self.$isActive, cityName: self.$cityName, nightMode: $darkMode),
                        isActive: self.$isActive,
                        label: {
                            ButtonView(buttonText: "Change location",
                                       backgroundColor: darkMode ? .blue : .white,
                                       foregroundColor: darkMode ? .white : .blue)
                        })
                        .isDetailLink(false)
                        .padding(.bottom, 5)
                    Button(action: {
                        darkMode.toggle()
                    }, label: {
                        ButtonView(buttonText: darkMode ? "Light Mode" : "Dark Mode",
                                   backgroundColor: darkMode ? .white : Color("darkgray"),
                                   foregroundColor: darkMode ? .blue : .white)
                    })

                }
            }
        }
        
    }
        
}

struct WeatherView: View {
    
    var cityWeather: String
    @Binding var isNight: Bool
    
    @State var data = Post(name: "Enschede", main: main(temp: 293.2 , feelsLike: 300, humidity: 0), sys: sys(country: "NL"), weather: [weather(main: "Clear", description: "Clear skies")])
    
    @State var mainIcon = "cloud.sun.fill"
    @State var nightIcon = "moon.stars.fill"
    
    func getData(city: String){
        let urlString =
            "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=1af38ed6a5458cefe67197a06c379bdd"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) {data, _, error in
            DispatchQueue.main.async {
                if let data = data{
                    
                    do{
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(Post.self, from: data)
                        print(decodedData.name)
                    
                        self.data = decodedData
                        
                        if (self.data.weather[0].main.contains("Clouds")){
                            mainIcon = "smoke.fill"
                            nightIcon = "cloud.moon.fill"
                        } else if(self.data.weather[0].main.contains("Clear")){
                            mainIcon = "sun.max.fill"
                            nightIcon = "moon.fill"
                        } else if(self.data.weather[0].main.contains("Rain")){
                            mainIcon = "cloud.drizzle.fill"
                            nightIcon = "cloud.moon.rain.fill"
                        }
                        else if(self.data.weather[0].main.contains("Snow")){
                            mainIcon = "snowflake"
                            nightIcon = "snowflake"
                        } else{
                            mainIcon = "cloud.sun.fill"
                            nightIcon = "moon.stars.fill"
                        }
                        
                    } catch{
                        let error = error
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
//    @State private var isNight = false
    
    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack{
                CityTextView(cityName: data.name + ", " + data.sys.country)
                MainTempView(imageName: isNight ? nightIcon :
                                mainIcon,
                             temperature: String(format: "%.1f", data.main.temp - 273.2), description: data.weather[0].description)
                    .padding(.bottom, 0)
                HStack(spacing:120){
                    InfoBox(title: "Weather", value: data.weather[0].main)
                    InfoBox(title: "Temperature", value: String(format: "%.1f", data.main.temp - 273.2) + "°")
                }
                .padding(.top, 0)
                .padding()
                HStack(spacing:130){
                    InfoBox(title: "Humidity", value: String(data.main.humidity) + "%")
                    InfoBox(title: "Feels like", value: String(format: "%.1f", data.main.feelsLike - 273.2) + "°")
                }
                .padding(.bottom, 10)
                .padding()
            }
        }
        .onAppear(perform: {self.getData(city: cityWeather); print(self.data.main); print(self.data.sys);
            print(self.data.weather[0])
        })
        .onReceive(timer, perform: { time in
            print("Updating the Data at time \(time)")
            self.getData(city: cityWeather)
        })
    }
}

struct LocationsView: View{
    
    @Binding var shouldPopToRootView: Bool
    @Binding var cityName: String
    @Binding var nightMode: Bool
    var locations: [Location] = MyLocations.mylocations
    var body: some View{
        ZStack{
            BackgroundView(isNight: $nightMode)
            VStack{
                List(locations, id: \.id){ item in
                    Button(action: {self.shouldPopToRootView = false; self.cityName = item.city}, label: {
                        HStack (spacing: 20){
                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                                .cornerRadius(4)
                            VStack(alignment: .leading, spacing: 5){
                                Text(item.city)
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                                    .minimumScaleFactor(0.5)
                                
                                Text(item.country)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    })
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

struct WeatherDayView: View {
    
    var dayOfTheWeek: String
    var imageName: String
    var temperature: String
    
    var body: some View {
        VStack{
            Text(dayOfTheWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? Color("darkgray") : Color("lightblue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct CityTextView: View{
    
    var cityName: String
    
    var body: some View{
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainTempView: View{
    
    var imageName: String
    var temperature: String
    var description: String
    
    var body: some View{
        VStack(spacing: 8){
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            Text("Current weather is: \(description) with current temperature of \(temperature) degrees.")
                .padding(30)
                .foregroundColor(.white)
        }
    }
}

struct InfoBox: View {
    
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .foregroundColor(Color("lightgray"))
            
            Text(value)
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .medium, design: .default))
        }
    }
}
