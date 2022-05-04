

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
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")

        try task.run()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}


struct MainWindow: View {
    @State var binaryPath = ""
    @State var extractionPath = ""
    @State var architectureIsArm = "arm64"
    let stringPath = Bundle.main.path(forResource: "llvm-lipo", ofType:.none)
    
    var body: some View {
        VStack {
            Picker(selection: $architectureIsArm, label: Text("Picker"),content: {
                Text("Extract Arm").tag("arm64")
                Text("Extract Intel").tag("x86_64")
            })
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(.top,40)
            .padding(.horizontal,100)
            
            
            
            Image(systemName: "terminal").padding(.top).font(.system(size:20))
            TextField("Path to Universal Binary", text: $binaryPath)
                .padding(.vertical,5)
                .padding(.horizontal)
            Image(systemName: "folder").padding(.top).font(.system(size:20))
            TextField("Path to where you want to save", text: $extractionPath)
                .padding(.vertical,5)
                .padding(.horizontal)
            Text("(You can drag and drop into fields)").foregroundColor(.secondary).padding(-5).font(.system(size:11))
            Image(systemName: "hammer").padding(.top,8).font(.system(size:20))
            Button("Extract")
                  {
                      do {
                          
                          let stringPathFormatted = stringPath!.replacingOccurrences(of: " ", with: #"\ "#)
                          let binPathFormatted = binaryPath.replacingOccurrences(of: " ", with: #"\ "#)
                          let extractPathFormatted = extractionPath.replacingOccurrences(of: " ", with: #"\ "#)
                          
                          
                          let partOne = stringPathFormatted + " -extract "
                          let partTwo = partOne + architectureIsArm + " " + binPathFormatted
                          let partThree = partTwo + " -output " + extractPathFormatted + "/Executable"
                          let result = try ShellCommands().safeShell(partThree)
                          print(partThree)
                          print(result)
                      }
                      catch {
                          print("\(error)") //handle or silence the error here
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


//"llvm-lipo -extract " + architecture + " " + MainWindow().binaryPath + " -output " + MainWindow().extractionPath
