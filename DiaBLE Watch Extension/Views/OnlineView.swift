import Foundation
import SwiftUI


struct OnlineView: View {
    @EnvironmentObject var app: AppState
    @EnvironmentObject var history: History
    @EnvironmentObject var settings: Settings

    @State private var readingCountdown: Int = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Image("Nightscout").resizable().frame(width: 24, height: 24).shadow(color: Color(UIColor.cyan), radius: 4.0 )
                    Text("https://").foregroundColor(Color(UIColor.lightGray))
                    Spacer()
                    Text("token").foregroundColor(Color(UIColor.lightGray))

                    VStack(spacing: 0) {

                        Button {
                            app.main.rescan()
                        } label: {
                                Image(systemName: "arrow.clockwise.circle").resizable().frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                                Text(app.deviceState == "Connected" && (readingCountdown > 0 || app.status.hasSuffix("sensor")) ?
                                        "\(readingCountdown) s" : "...")
                                    .fixedSize()
                                    .onReceive(timer) { _ in
                                        readingCountdown = settings.readingInterval * 60 - Int(Date().timeIntervalSince(app.lastReadingDate))
                                    }.foregroundColor(.orange).font(Font.footnote.monospacedDigit())
                            }
                    }
                }

                HStack {
                    TextField("Nightscout URL", text: $settings.nightscoutSite)
                    SecureField("token", text: $settings.nightscoutToken)
                }

                //                WebView(site: settings.nightscoutSite, query: "token=\(settings.nightscoutToken)", delegate: app.main?.nightscout )
                //                    .frame(height: UIScreen.main.bounds.size.height * 0.60)
                //                    .alert(isPresented: $app.showingJavaScriptConfirmAlert) {
                //                        Alert(title: Text("JavaScript"),
                //                              message: Text(app.JavaScriptConfirmAlertMessage),
                //                              primaryButton: .default(Text("OK")) {
                //                                app.main.log("JavaScript alert: selected OK") },
                //                              secondaryButton: .cancel(Text("Cancel")) {
                //                                app.main.log("JavaScript alert: selected Cancel") }
                //                        )
                //                }

            }.font(.footnote)

            List {
                ForEach(history.nightscoutValues) { glucose in
                    (Text("\(String(glucose.source[..<(glucose.source.lastIndex(of: " ") ?? glucose.source.endIndex)])) \(glucose.date.shortDateTime)") + Text("  \(glucose.value, specifier: "%3d")").bold())
                        .fixedSize(horizontal: false, vertical: true).listRowInsets(EdgeInsets())
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            // .font(.system(.footnote, design: .monospaced))
            .foregroundColor(Color(UIColor.cyan))
            .onAppear { if let nightscout = app.main?.nightscout { nightscout.read()
                app.main.log("nightscoutValues count \(history.nightscoutValues.count)")

            } }
        }
        .navigationTitle("Online")
        .edgesIgnoringSafeArea([.bottom])
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(Color(UIColor.cyan))

    }
}


struct OnlineView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            OnlineView()
                .environmentObject(AppState.test(tab: .online))
                .environmentObject(History.test)
                .environmentObject(Settings())
        }
    }
}
