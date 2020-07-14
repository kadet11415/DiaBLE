import SwiftUI


struct ContentView: View {

    @EnvironmentObject var app: AppState
    @EnvironmentObject var log: Log
    @EnvironmentObject var history: History
    @EnvironmentObject var settings: Settings

    @State var isMonitorActive: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: -4) {
                    HStack(spacing: 10) {
                        NavigationLink(destination: Monitor().environmentObject(app).environmentObject(history).environmentObject(settings), isActive: $isMonitorActive) {
                            VStack {
                                Image(systemName: "gauge").resizable().frame(width: 40, height: 40).offset(y: 4)
                                Text("Monitor").bold().foregroundColor(.blue)
                            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                        NavigationLink(destination: Details().environmentObject(app).environmentObject(settings)) {
                            VStack {
                                Image(systemName: "info.circle").resizable().frame(width: 40, height: 40).offset(y: 4)
                                Text("Details").bold().foregroundColor(.blue).bold()
                            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                    }
                    HStack(spacing: 10) {
                        NavigationLink(destination: LogView().environmentObject(app).environmentObject(log).environmentObject(settings)) {
                            VStack {
                                Image(systemName: "doc.plaintext").resizable().frame(width: 40, height: 40).offset(y: 4)
                                Text("Log").bold().foregroundColor(.blue)
                            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                        NavigationLink(destination: SettingsView().environmentObject(app).environmentObject(log).environmentObject(history).environmentObject(settings)) {
                            VStack {
                                Image(systemName: "gear").resizable().frame(width: 40, height: 40).offset(y: 4)
                                Text("Settings").bold().tracking(-0.5).foregroundColor(.blue)
                            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                    }
                    HStack(spacing: 10) {
                        // TODO
                        NavigationLink(destination: DataView().environmentObject(app).environmentObject(log).environmentObject(history).environmentObject(settings)) {
                            VStack {
                                Image(systemName: "tray.full.fill").resizable().frame(width: 40, height: 40).offset(y: 4)
                                Text("Data").bold().foregroundColor(.blue)
                            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                        NavigationLink(destination: OnlineView().environmentObject(app).environmentObject(history).environmentObject(settings)) {
                            VStack {
                                Image(systemName: "globe").resizable().frame(width: 40, height: 40).offset(y: 4)
                                Text("Online").bold().foregroundColor(.blue)
                            }.frame(maxWidth: .infinity).padding(.vertical, 6)
                        }
                    }
                }
                .foregroundColor(.red)
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("DiaBLE  \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)")
        }
        .edgesIgnoringSafeArea([.bottom])
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var app: AppState
    @EnvironmentObject var log: Log
    @EnvironmentObject var history: History
    @EnvironmentObject var settings: Settings

    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(AppState.test(tab: .monitor))
                .environmentObject(Log())
                .environmentObject(History.test)
                .environmentObject(Settings())
        }
    }
}
