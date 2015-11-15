//
//  BarCodeScannerViewController.swift
//  HackSC2015
//
//  Created by Ashan Marla on 11/14/15.
//
//

import UIKit
import AVFoundation

class BarCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = try! AVCaptureDeviceInput(device: device)
        session.addInput(input)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer = previewLayer
        view.layer.addSublayer(previewLayer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        session.startRunning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadata in metadataObjects as! [AVMetadataObject] {
            if metadata.type == AVMetadataObjectTypeQRCode {
                let value = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                let data = value.dataUsingEncoding(NSUTF8StringEncoding)!
                let info = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(info)
                performSegueWithIdentifier("ShowReceipt", sender: self)
                session.stopRunning()
                return
            }
        }
    }
    

    //testpush


}

