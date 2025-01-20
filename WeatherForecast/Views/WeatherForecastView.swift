//
//  ContentView.swift
//  WeatherForecast
//
//  Created by HongDi Huang on 2025/1/20.
//

import SwiftUI
import Charts


struct WeatherForecastView: View {
    @State private var orientation = UIDevice.current.orientation
    
    @StateObject var viewModel = WeatherForecastViewModel()
    @State private var scrollWidth: CGFloat = 450.0
    @State private var savedScrollWidth: CGFloat = 1320.0
    
    private let minScrollWidth: CGFloat = 450.0
    private let maxScrollWidth: CGFloat = 3200.0
    
    var skeletonData: [TemperatureModel] {
        return [
            TemperatureModel(date: "2025-01-19T19:00", temperature: "20"),
            TemperatureModel(date: "2025-01-20T19:00", temperature: "10"),
            TemperatureModel(date: "2025-01-21T19:00", temperature: "20"),
            TemperatureModel(date: "2025-01-22T19:00", temperature: "30")]
    }
    
    var body: some View {
        VStack{
            let layout = orientation.isLandscape ? AnyLayout(HStackLayout()): AnyLayout(VStackLayout())
            
            layout {
                ScrollView(.horizontal) {
                    lineChart
                        .skeleton(isLoading: viewModel.isLoading)
                }
                .gesture(
                    magnification
                )
                
                List{
                    Section(header:VStack(spacing: 10, content:{
                        HStack {
                            Text("Time").font(.headline)
                            Spacer()
                            Text("Temperature").font(.headline)
                        }
                        HStack {
                            Text(viewModel.address ?? "").font(.subheadline)
                            Spacer()
                        }
                    }).padding(.vertical, 5))
                    {
                        ForEach(viewModel.isLoading ? skeletonData : viewModel.data, id:\.id) { item in
                            HStack(){
                                Text("\(item.itemDate)")
                                Spacer()
                                Text("\(item.itemTemperature)")
                            }
                            .skeleton(isLoading: viewModel.isLoading)
                        }
                    }
                    
                }.listStyle(PlainListStyle())
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown Error"),
                    dismissButton: .default(Text("OK")) {
                        viewModel.errorMessage = nil
                    })
            }
            .onAppear {
                viewModel.requestData()
            }
            
            
        }.detectOrientation($orientation)
        
    }
    
    var magnification: some Gesture {
        
        return MagnificationGesture()
            .onChanged { value in
                let calculatedWidth = savedScrollWidth * value
                scrollWidth = max(min(calculatedWidth, maxScrollWidth), minScrollWidth)
                print("Value: \(value), Scroll Width: \(scrollWidth)")
                print(scrollWidth)
            }.onEnded { val in
                
                
                self.savedScrollWidth = self.scrollWidth
                print("On End - Scroll Width: \(scrollWidth)")            }
        
    }
    
    private var lineChart: some View {
        Chart(viewModel.isLoading ? skeletonData : viewModel.data, id: \.id) { chartData in
            let linkeMarker = getBaselineMarker(marker: chartData)
            if(viewModel.markData.contains(chartData)) {
                linkeMarker.symbol(Circle().strokeBorder(lineWidth: 0.5))
            }else {
                linkeMarker
            }
        }
        .chartYAxis {
            AxisMarks(preset: .automatic, position: .leading)
        }
        .padding()
        .frame(width: scrollWidth, height: 300)
        .chartXVisibleDomain(length: 86400*2)//86400 = 24 hours
        
    }
    
    private func getBaselineMarker (marker: TemperatureModel) -> some ChartContent {
        return LineMark(
            x: .value("Month", marker.formattedDate),
            y: .value("Hours", marker.formattedTemperature)
        )
        .accessibilityLabel(marker.formattedDate.formatted(date: .complete, time: .omitted))
        .accessibilityValue("\(marker.formattedTemperature) °C")
    }
    
}

#Preview {
    WeatherForecastView()
}
