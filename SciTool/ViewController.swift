//
//  ViewController.swift
//  SciTool
//
//  Created by Marc D. Nichitiu on 2/7/22.
//

import PythonKit
import os
import Cocoa


class SplashViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    
    
    @IBAction func openEquipotentialGrapher(sender: Any?)
    {
        print(" yo ")
        self.view.window?.close()
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "EquipotGrapher") as! NSWindowController
        windowController.showWindow(self)
    }
    @IBAction func viewListOfCalculators(sender: Any?)
    {
        self.view.window?.close()
        let alert: NSAlert = NSAlert()
        alert.messageText = "Not Available Yet"
        alert.informativeText = "This feature is not available yet. Please check back on the webpage for a new version that may include this feature."
        alert.alertStyle = NSAlert.Style.informational
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
        // TODO
    }
    @IBAction func openPrefs(sender: Any?)
    {
        // self.view.window?.close()
        // TODO
    }
}


class NewViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
}

class EquipotViewController: NSViewController {

    @IBAction func openGithub(sender: Any?)
    {
        let url = URL(string: "https://github.com/MDNich/SciTool")!
        if NSWorkspace.shared.open(url) {
            print("Browser Successfully opened")
        }
    }
    
    @IBOutlet weak var scrollViewHelp: NSScrollView!
    
    var imgIsReset: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ok cool we're in business")
        if let _ = scrollViewHelp {
            print("ok cool we really are in business")
        }
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var img: NSImageView!
    
    @IBOutlet weak var ChargeXList: NSTextField!
    
    @IBOutlet weak var ChargeYList: NSTextField!
    
    @IBOutlet weak var ChargeQList: NSTextField!
    
    @IBOutlet weak var CoulombConstant: NSTextField!
    
    @IBOutlet weak var WindowLowerX: NSTextField!
    
    @IBOutlet weak var WindowUpperX: NSTextField!
    
    @IBOutlet weak var WindowLowerY: NSTextField!
    
    @IBOutlet weak var WindowUpperY: NSTextField!
    
    @IBOutlet weak var CounterNumber: NSTextField!
    
    @IBOutlet weak var ScatterPtDensity: NSTextField!
    
    @IBOutlet weak var DPI: NSTextField!
    
    @IBOutlet weak var ErrorLabel: NSTextField!
    
    //pathToSave,chargeXarr,chargeYarr,chargeQarr,windowLBoundX,windowLBoundY,windowUBoundX,windowUBoundY,steps,countourprec
    @IBOutlet weak var ProgressBar: NSProgressIndicator!
    
    @IBOutlet weak var savebutton: NSButton!
    
    
    @IBOutlet weak var helpButton: NSButton!
    
    @IBAction func saveImgAs(sender: Any?)
    {
        
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["png"]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save generated image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.prompt = "Save"
        savePanel.nameFieldLabel = "File name:"
        savePanel.nameFieldStringValue = "EquipotentialLines"
        guard let window = self.view.window else { return }
        let response = savePanel.runModal()
        guard response == .OK, let saveURL = savePanel.url else { return }
        print("response: \(response)")
        print("saveURL: \(saveURL)")
        var dirPath = FileManager.default.temporaryDirectory.absoluteString
        let img = img.image
        print(img)
        if ((img?.pngWrite(to: saveURL)) != nil) {
                    print("File saved")
                }
               
        
    }
    
    
    func doImgRender()
    {
        ErrorLabel.isHidden = true
        var dirPath = FileManager.default.temporaryDirectory.absoluteString
        print(dirPath)
        dirPath.removeFirst(6)
        do {
            try runPythonCode(dirPathSave: dirPath) }
        catch {
            print("FAILED")
            dirPath = Bundle.main.resourcePath!
            img.image = NSImage(contentsOfFile: "\(dirPath)/blank.png")
            ErrorLabel.isHidden = false
            savebutton.isEnabled = false
        }
        img.image = NSImage(contentsOfFile: "\(dirPath)/result.png")
        self.imgIsReset = false
        savebutton.isEnabled = true

    }
    
    @IBAction func exec(_ sender: Any) {
        self.ProgressBar.doubleValue = 30
        if(!imgIsReset) {
            img.image = NSImage(named: "Empty")
            self.imgIsReset = true
            DispatchQueue.main.async {
                self.doImgRender()
                self.ProgressBar.doubleValue = 100
            }
            
            return
        }
        else {
            doImgRender()
        }
        
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func convertStringToArr(str: String) -> Array<Int>
    {
        let tmp = str.split(separator: Character(","))
        var tmp2 = Array<Int>()
        for str in tmp {
            tmp2.append(Int(str) ?? 0)
        }
        return tmp2
        
    }
    func runPythonCode(dirPathSave: String) throws {
       // var mainBundle = resourcePath
        let dirPath = Bundle.main.resourcePath!
        print(dirPath)
        let xs = convertStringToArr(str: ChargeXList.stringValue)
        let ys = convertStringToArr(str: ChargeYList.stringValue)
        let qs = convertStringToArr(str: ChargeQList.stringValue)
        
        let sys = Python.import("sys")
        sys.path.append(dirPath)
        let engine = Python.import("voltage")
        let arr = [PythonObject.StringLiteralType(dirPathSave),PythonObject.ArrayLiteralElement(ys),PythonObject.ArrayLiteralElement(xs),PythonObject.ArrayLiteralElement(qs),PythonObject.FloatLiteralType(Double(WindowLowerX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowLowerY.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperY.stringValue)!),PythonObject.IntegerLiteralType(Int(ScatterPtDensity.stringValue)!),PythonObject.IntegerLiteralType(Int(CounterNumber.stringValue)!),PythonObject.FloatLiteralType(Double(CoulombConstant.stringValue)!),PythonObject.FloatLiteralType(Double(DPI.stringValue)!)] as [PythonConvertible]
        try engine.drawGraph.throwing.dynamicallyCall(withArguments: arr)
       // try engine.from_env.throwing.dynamicallyCall(withArguments: arr)
        /*try engine.drawGraph(PythonObject.StringLiteralType(dirPathSave),PythonObject.ArrayLiteralElement(ys),PythonObject.ArrayLiteralElement(xs),PythonObject.ArrayLiteralElement(qs),PythonObject.FloatLiteralType(Double(WindowLowerX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowLowerY.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperX.stringValue)!),PythonObject.FloatLiteralType(Double(WindowUpperY.stringValue)!),PythonObject.IntegerLiteralType(Int(ScatterPtDensity.stringValue)!),PythonObject.IntegerLiteralType(Int(CounterNumber.stringValue)!),PythonObject.FloatLiteralType(Double(CoulombConstant.stringValue)!),PythonObject.FloatLiteralType(Double(DPI.stringValue)!))*/
       //try engine.drawGraph()*/
    }


}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
