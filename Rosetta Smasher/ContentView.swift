

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainWindow()
            .background(VisualEffectView(material: NSVisualEffectView.Material.contentBackground, blendingMode: NSVisualEffectView.BlendingMode.withinWindow))
            .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class ShellCommands {
    func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}


struct MainWindow: View {
    @State var filename = "Filename"
    @State var showFileChooser = false
    
    
    var body: some View {
        VStack {
            Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Picker")) {
                Text("Extract Arm").tag(1)
                Text("Extract Intel").tag(2)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(.top,40)
            .padding(.horizontal,100)
            Image(systemName: "terminal").padding(.top).font(.system(size:20))
            Button("Select a Universal Binary")
                  {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        self.filename = panel.url?.lastPathComponent ?? "<none>"
                    }
                  }
                  .padding(5)
            Image(systemName: "folder").padding(.top).font(.system(size:20))
            Button("Select where to save the file")
                  {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        self.filename = panel.url?.lastPathComponent ?? "<none>"
                    }
                  }
                  .padding(5)
            Image(systemName: "hammer").padding(.top).font(.system(size:20))
            Button("Extract")
                  {
                    let panel = NSOpenPanel()
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = false
                    if panel.runModal() == .OK {
                        self.filename = panel.url?.lastPathComponent ?? "<none>"
                    }
                  }
                  .padding(5)
                  .keyboardShortcut(.defaultAction)
            
           
        }
        .frame(width: 400, height: 300,alignment:.top)
    }
}

struct VisualEffectView: NSViewRepresentable
{
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .popover
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = .popover
        visualEffectView.blendingMode = .behindWindow
    }
}




//VStack {
//
//}.frame(width:300,height:230)
//    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.secondary,lineWidth: 1).opacity(0.5))
