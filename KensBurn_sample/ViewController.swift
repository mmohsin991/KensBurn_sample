//
//  ViewController.swift
//  KensBurn_sample
//
//  Created by Panacloud on 04/03/2015.
//  Copyright (c) 2015 Panacloud. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CoreMedia
import MediaPlayer
import MobileCoreServices
import AssetsLibrary





class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MPMediaPickerControllerDelegate{
    var firrstassest:AVAsset!
    var Audioasset:AVAsset!
    var paths=[NSURL]()
    var images:[UIImage] = []
    var audioUrl:NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.append(UIImage(named: "1.jpeg"))
        images.append(UIImage(named: "2.jpeg"))
        images.append(UIImage(named: "images.png"))
//        images.append(UIImage(named: "1.jpeg"))
        
    }

    @IBAction func Merge(sender: AnyObject) {
//        println(paths.count)
//        println(images.count)
//        if paths.count == images.count {
//            println("Done.")
//            self.mergeVideos(paths)
//        }
    }
    @IBAction func LoadAsset(sender: AnyObject) {
//        self.startMediaBrowserFromViewController()
    }
   
    @IBAction func Generate(sender: AnyObject) {
        
//        for i in images {
//       
//            self.VideoOut(i as UIImage)
//            
//           
//            }
//
        audioUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("humtap", ofType: "mp3")!)!

        let imgsToVideo = ImgsToVideo()
        
        imgsToVideo.imgsToVid(self.images, audioUrl: audioUrl) { (outputVideo) -> Void in
            self.runAVPlayer(outputVideo)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func startMediaBrowserFromViewController(){
        var mediaUI:UIImagePickerController = UIImagePickerController()
        mediaUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        mediaUI.allowsEditing=true
        mediaUI.delegate=self
        mediaUI.mediaTypes = [kUTTypeMovie!]
        presentViewController(mediaUI, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
       
        var mediatype:NSString=info[UIImagePickerControllerMediaType] as NSString
        dismissViewControllerAnimated(true, completion: nil)
        
            var alert = UIAlertView(title: "Assest loaded ", message: "video one load", delegate: nil, cancelButtonTitle: "ok")
            alert.show()
            var i:NSURL? = info[UIImagePickerControllerMediaURL] as? NSURL
            firrstassest    = AVAsset.assetWithURL(i) as? AVAsset
            println(firrstassest)
            

        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

    
    func runAVPlayer(url: NSURL){
        let av = AVPlayerViewController()
        let player = AVPlayer(URL: url)
        av.player = player
        self.presentViewController(av, animated: true, completion: nil)
    }

}


    
