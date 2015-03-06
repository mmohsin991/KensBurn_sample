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
//        images.append(UIImage(named: "images.png"))
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
        audioUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Buzz", ofType: "mp3")!)!

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
    





class ImgsToVideo {

    
    var firrstassest:AVAsset!
    var Audioasset:AVAsset!
    var pathsUrl = [NSURL]()
    var imagesGlobal : [UIImage]!
    
    
    func imgsToVid(images: [UIImage], audioUrl : NSURL , callBack : (outputVideo : NSURL) -> Void){
        
        
        
        imagesGlobal = images
        

        func VideoOut(image:UIImage, callBack : (outputVideo : NSURL) -> Void){
            
            var i:NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("temp", ofType: "mp4")!)!
            firrstassest    = AVAsset.assetWithURL(i) as AVAsset
            //        println(firrstassest)
            
            //audioUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("Buzz", ofType: "mp3")!)!
            Audioasset  = AVAsset.assetWithURL(audioUrl) as AVAsset
            //        println(Audioasset)
            
            
            if firrstassest==nil{
                var alert = UIAlertView(title: "no asset loaded ", message: "please load video", delegate: nil, cancelButtonTitle: "ok")
                alert.show()
            }else{
                
                
                var mixComposition:AVMutableComposition = AVMutableComposition()
                
                var videTrack:AVMutableCompositionTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32 (kCMPersistentTrackID_Invalid))
                var AudioTrack:AVMutableCompositionTrack=mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
                
                
                AudioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, Audioasset.duration), ofTrack: Audioasset.tracksWithMediaType(AVMediaTypeAudio)[0] as AVAssetTrack, atTime: kCMTimeZero, error: nil)
                println("duration=\(Audioasset.duration.value)")
                
                videTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, Audioasset.duration), ofTrack: firrstassest.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack, atTime: kCMTimeZero, error: nil)
                
                var mainInstruction:AVMutableVideoCompositionInstruction=AVMutableVideoCompositionInstruction()
                
                
                mainInstruction.timeRange=CMTimeRangeMake(kCMTimeZero, Audioasset.duration)
                
                var videoLayerinstruction:AVMutableVideoCompositionLayerInstruction=AVMutableVideoCompositionLayerInstruction(assetTrack: videTrack)
                
                
                var videAssetTrack:AVAssetTrack = firrstassest.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
                
                
                var videoAssetOrientation:UIImageOrientation = UIImageOrientation.Up
                
                var isVideoAssetPotriat=false
                
                var videotransform:CGAffineTransform=videAssetTrack.preferredTransform
                
                if videotransform.a == 0 && videotransform.b == 1.0 && videotransform.c == -1.0 && videotransform.d == 0 {
                    videoAssetOrientation=UIImageOrientation.Right
                    isVideoAssetPotriat=true
                }
                if videotransform.a == 0 && videotransform.b == -1.0 && videotransform.c == 1.0 && videotransform.d == 0 {
                    videoAssetOrientation=UIImageOrientation.Left
                    isVideoAssetPotriat=true
                }
                if videotransform.a == 1.0 && videotransform.b == 0 && videotransform.c == 0 && videotransform.d == 1.0 {
                    videoAssetOrientation=UIImageOrientation.Up
                }
                if videotransform.a == -1.0 && videotransform.b == 0 && videotransform.c == 0 && videotransform.d == -1.0 {
                    videoAssetOrientation=UIImageOrientation.Down
                }
                
                videoLayerinstruction.setTransform(videAssetTrack.preferredTransform, atTime: kCMTimeZero)
                videoLayerinstruction.setOpacity(0.0, atTime: Audioasset.duration)
                
                
                mainInstruction.layerInstructions = NSArray(objects: videoLayerinstruction)
                
                var maincompositionInst:AVMutableVideoComposition = AVMutableVideoComposition()
                var naturalsize:CGSize
                
                if isVideoAssetPotriat {
                    naturalsize=CGSizeMake(videAssetTrack.naturalSize.height, videAssetTrack.naturalSize.width)
                    
                }else{
                    naturalsize=videAssetTrack.naturalSize
                }
                
                var renderWidth:CGFloat=naturalsize.width
                var renderHeight:CGFloat=naturalsize.height
                maincompositionInst.renderSize=CGSizeMake(renderWidth, renderHeight)
                maincompositionInst.instructions=NSArray(object: mainInstruction)
                maincompositionInst.frameDuration=CMTimeMake(1, 30)
                
                
                
                self.applyVideoEffectsToComposition(maincompositionInst,size: naturalsize, image: image)
                
                
                
                var paths:NSArray=NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
                var documentDirectory:NSString=paths.objectAtIndex(0) as NSString
                var myPathDocs = documentDirectory.stringByAppendingPathComponent(NSString(format: "FinalVideo-%d.mov", arc4random()%1000))
                var url = NSURL.fileURLWithPath(myPathDocs)
                
                //            self.paths.append(url!)
                
                
                var exporter:AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
                
                exporter.outputURL=url
                exporter.outputFileType=AVFileTypeQuickTimeMovie
                exporter.shouldOptimizeForNetworkUse=true
                exporter.videoComposition=maincompositionInst
                exporter.exportAsynchronouslyWithCompletionHandler({
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.pathsUrl.append(url!)
                        
                        self.exportDidFinish(exporter)
                        
                        println(paths)
                        println(images)
                        println("\(paths.count) = \(images.count)")
                        
                        if self.pathsUrl.count == images.count {
                            println("Done.")
                            //mergeVideos(pathsUrl)
                            self.mergeVideos(self.pathsUrl, { (outputVideo) -> Void in
                                
                                callBack(outputVideo: outputVideo)
                            })
                        }
                        
                    })
                })
                
                
            }
        }
        
        
        
        
        var count: Int = 0
        
        for i in images {
            
            //  VideoOut(i as UIImage)
            VideoOut(i as UIImage, { (outputVideo) -> Void in
                
                
                callBack(outputVideo: outputVideo)
                //            count += 1
                //
                //            if count == images.count {
                //                callBack(outputVideo: outputVideo)
                //            }
                
                
            })
            
        }
        
        
    }
    
    
    
    
    
    func mergeVideos(paths:[NSURL], callBack : (outputVideo : NSURL) -> Void){
        var asset = [AVAsset]()
        
        for  p in paths {
            asset.append(AVAsset.assetWithURL(p) as AVAsset)
        }
        
        var mixcomposition:AVMutableComposition=AVMutableComposition()
        
        var firsttrack:AVMutableCompositionTrack=mixcomposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32 (kCMPersistentTrackID_Invalid))
        
        
        
        for  a in asset {
            
            firsttrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, a.duration), ofTrack: a.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack, atTime: kCMTimeZero, error: nil)
            
            
        }
        
        
        
        
        
        //        firsttrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, Secondassest!.duration), ofTrack: Secondassest?.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack, atTime: kCMTimeZero, error: nil)
        //
        //        var alayer:CALayer=CALayer()
        //        alayer.contents=UIImage(named: "images.png")
        //        alayer.frame=CGRectMake(0, 0, 320  , 480)
        //        alayer.masksToBounds=true
        //
        //
        //        var videoLayer:CALayer=CALayer()
        //        videoLayer.frame=CGRectMake(50, 50, 300, 400)
        //
        //        var parentLayer:CALayer=CALayer()
        //        parentLayer.frame=CGRectMake(0, 0, 320, 480)
        //        parentLayer.addSublayer(alayer)
        //        parentLayer.addSublayer(videoLayer)
        //
        //
        //        var videcomp:AVMutableVideoComposition=AVMutableVideoComposition(propertiesOfAsset: mixcomposition)
        //        videcomp.animationTool=AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
        
        var paths:NSArray=NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var ddocumentDirectory:NSString=paths.objectAtIndex(0) as NSString
        var str:NSString=NSString(format: "mergeVideo-%d.mp4", arc4random()%1000)
        var myPathDocss:NSString=ddocumentDirectory.stringByAppendingPathComponent(str)
        
        
        var url:NSURL=NSURL.fileURLWithPath(myPathDocss)!
        
        var exporter:AVAssetExportSession = AVAssetExportSession(asset: mixcomposition, presetName: AVAssetExportPresetHighestQuality)
        exporter.outputURL=url
        exporter.outputFileType=AVFileTypeQuickTimeMovie
        exporter.shouldOptimizeForNetworkUse=true
        exporter.exportAsynchronouslyWithCompletionHandler({
            dispatch_async(dispatch_get_main_queue(), {
                
                self.exportDidFinish(exporter)
                callBack(outputVideo: url)
                
                //runAVPlayer(url)
            })
        })
        
    }
    
    func exportDidFinish(session:AVAssetExportSession){
        
        if session.status == AVAssetExportSessionStatus.Completed {
            var outputUrl:NSURL=session.outputURL as NSURL
            
            println("abdc")
            //            var library:ALAssetsLibrary=ALAssetsLibrary()
            
            //            if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(outputUrl){
            //
            //
            //                library.writeVideoAtPathToSavedPhotosAlbum(outputUrl, completionBlock: {(asseetUrl:NSURL!,Error:NSError!) in
            //
            //
            //                    dispatch_async(dispatch_get_main_queue(),{
            //                        if let temp=Error{
            //                            var alert = UIAlertView(title: "Error", message: "failed", delegate: nil, cancelButtonTitle: "ok")
            //                            alert.show()
            //                        }else{
            //                            var alert = UIAlertView(title: "Video Saved", message: "Saved to photo album", delegate: nil, cancelButtonTitle: "ok")
            //                            alert.show()
            //                        }
            //
            //                    })
            //
            //
            //                })
            Audioasset = nil
            firrstassest = nil
            //            }
            
        }
    }
    
    func applyVideoEffectsToComposition(mainCompositionInstruction:AVMutableVideoComposition,size:CGSize,image:UIImage ){
        var flip = Float()
        if imagesGlobal != nil {
            let index = find(imagesGlobal, image)!
            flip = index % 2 == 0 ? -1.0 : 1.0
            
        }
        
        
        
        var animation1=CABasicAnimation(keyPath: "transform.scale")
        animation1.duration=70
        animation1.repeatCount=10
        animation1.autoreverses=true
        //        animation1.fromValue=NSNumber(float: 1)
        animation1.toValue=NSNumber(float:2 * flip )
        animation1.beginTime=AVCoreAnimationBeginTimeAtZero
        
        
        var animation:CABasicAnimation=CABasicAnimation(keyPath: "opacity")
        animation.duration=70
        animation.repeatCount=10
        animation.autoreverses=true
        //        animation.fromValue=NSNumber(float:1.0)
        animation.toValue=NSNumber(float: 0.0 * flip)
        animation.beginTime=AVCoreAnimationBeginTimeAtZero
        
        
        
        var animation2:CABasicAnimation=CABasicAnimation(keyPath: "position.x")
        animation2.duration=70
        animation2.repeatCount=10
        animation2.autoreverses=true
        //        animation2.fromValue=NSNumber(float:(150 * flip))
        animation2.toValue=NSNumber(float: (-150 * flip))
        animation2.beginTime=AVCoreAnimationBeginTimeAtZero
        
        
        
        
        var group = CAAnimationGroup()
        group.animations = [animation,animation1,animation2]
        group.duration=150
        group.beginTime = 1e-100
        group.fillMode=kCAFillModeForwards
        group.removedOnCompletion=false
        
        
        
        
        var backgroundLayer=CALayer()
        backgroundLayer.contents=image.CGImage
        backgroundLayer.frame=CGRectMake(0, 0, size.width, size.height)
        backgroundLayer.masksToBounds=true
        backgroundLayer.addAnimation(group, forKey: "group")
        
        
        var videoLayer = CALayer()
        videoLayer.frame = CGRectMake(0, 0, size.width , size.height)
        
        
        var parentlayer=CALayer()
        parentlayer.frame=CGRectMake(0, 0, size.width, size.height)
        
        parentlayer.addSublayer(videoLayer)
        parentlayer.addSublayer(backgroundLayer)
        
        
        mainCompositionInstruction.animationTool=AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentlayer)
        
    }

}
