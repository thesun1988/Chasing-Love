//
//  GameViewController.swift
//  Serva me, servabo te
//
//  Created by Mihails Tumkins on 06/01/16.
//  Copyright (c) 2016 Mihails Tumkins. All rights reserved.
//

import UIKit
import SpriteKit
import iAd
import AVFoundation
import GameKit
import GoogleMobileAds
import Social

class GameViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate, ADInterstitialAdDelegate, GADBannerViewDelegate, GADInterstitialDelegate {

    var interstitialAd:ADInterstitialAd!
    var interstitialAdView: UIView = UIView()
    var bannerView: ADBannerView!

    var adMobBannerView: GADBannerView!
    var adMobInterstitial: GADInterstitial!

    var player: AVAudioPlayer!

    override func viewDidLoad() {
        if Config.soundsEnabled {
            setupBackgroundMusic()
        }

        if Config.gameCenterEnabled {
            authenticateLocalPlayer()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLeaderboard", name: "showLeaderboard", object: nil)
        }

//        if Config.iAdEnabled && !Config.adMobEnabled {
//            setupiAd()
//        } else if !Config.iAdEnabled && Config.adMobEnabled {
//            setupAdmobAd()
//        } else if Config.iAdEnabled && Config.adMobEnabled {
//            let rand = Int(arc4random_uniform(UInt32(2)))
//            if rand == 1 {
//                setupAdmobAd()
//            } else {
//                setupiAd()
//            }
//        }
        if Config.adMobEnabled {
            setupAdmobAd()
        }
        
//        if Config.iAdInterstitialEnabled {
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "showInterstitialAd", name: "showInterstitialAd", object: nil)
//        }

        if Config.adMobInterstitialEnabled {
            createAndLoadAdMobInterstitial()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAdMobInterstitialAd", name: "showAdMobInterstitialAd", object: nil)
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shareScore", name: "shareScore", object: nil)

        let scene = MenuScene()
        scene.scaleMode = .AspectFill
        scene.size = Config.sceneSize

        let skView = self.view as! SKView

        if Config.debugModeEnabled {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsDrawCount = true
            skView.showsPhysics = true
            skView.showsFields = true
            skView.showsQuadCount = true
        }

        skView.presentScene(scene)
    }

    // music player
    func setupBackgroundMusic() {

        let url: NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(Config.backgroundMusicFileName, ofType: "mp3")!)
        do {
            try player = AVAudioPlayer(contentsOfURL: url)
            player.numberOfLoops = -1
            player.volume = 0.5
            player.play()
        } catch {
            print("player not loaded")
        }
    }

    // Game Center
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            if ((viewController) != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            } else {
                print("(GameCenter) Player authenticated: \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }

    func showLeaderboard() {
//        let localPlayer = GKLocalPlayer.localPlayer()
//        
//        if (localPlayer.authenticated)
//        {
        let viewController: GKGameCenterViewController = GKGameCenterViewController()
        viewController.gameCenterDelegate = self
        viewController.viewState = GKGameCenterViewControllerState.Leaderboards
        viewController.leaderboardIdentifier = Config.remoteLeaderboardID
        self.presentViewController(viewController, animated: true, completion: nil)
        
//        else
//        {
//            authenticateLocalPlayer()
//        }
    }

    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    // iAd & admob
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false
    }

    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        bannerView.hidden = true
    }

    func setupAdmobAd() {
        print("setting app admob")

        let adHeight = CGSizeFromGADAdSize(kGADAdSizeSmartBannerLandscape).height

        adMobBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape,
            origin: CGPointMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame) - adHeight))

        adMobBannerView.adUnitID = Config.admobBannerId
        adMobBannerView.delegate = self
        adMobBannerView.rootViewController = self
        view.addSubview(adMobBannerView)

        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        adMobBannerView.loadRequest(request)
    }

    func setupiAd() {
        print("setting app iad")
        bannerView = ADBannerView(adType: .Banner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        bannerView.hidden = true
        view.addSubview(bannerView)
        let viewsDictionary = ["bannerView": bannerView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))

    }

    // MARK: - adMob INTERSTITIAL ADS
    func createAndLoadAdMobInterstitial() {
        adMobInterstitial = GADInterstitial(adUnitID: Config.admobInterstitialId)
        adMobInterstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        adMobInterstitial.loadRequest(request)
    }

    func showAdMobInterstitialAd(){
        print("received showAdMobInterstitialAd notification")
        if adMobInterstitial.isReady {
            adMobInterstitial.presentFromRootViewController(self)
        }
    }

    /// Called when an interstitial ad request succeeded.
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        print("interstitialDidReceiveAd")
    }

    /// Called when an interstitial ad request failed.
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Called just before presenting an interstitial.
    func interstitialWillPresentScreen(ad: GADInterstitial!) {
        print("interstitialWillPresentScreen")
    }

    /// Called before the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        print("interstitialWillDismissScreen")
    }

    /// Called just after dismissing an interstitial and it has animated off the screen.
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        createAndLoadAdMobInterstitial()
    }


    /// Called just before the application will background or terminate because the user clicked on an
    /// ad that will launch another app (such as the App Store).
    func interstitialWillLeaveApplication(ad: GADInterstitial!) {
        print("interstitialWillLeaveApplication")
    }


    // MARK: -  iAD INTERSTITIAL ADS
    func showInterstitialAd() {
        print("received showInterstitialAd request")
        interstitialAd = ADInterstitialAd()
        interstitialAd.delegate = self
    }

    func interstitialAdWillLoad(interstitialAd: ADInterstitialAd!) {

    }

    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        view.addSubview(interstitialAdView)
        interstitialAd.presentInView(interstitialAdView)
        UIViewController.prepareInterstitialAds()
        print("ad did load")

    }

    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        print("ad finished")
    }

    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }

    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        print("ad failed with error")
    }

    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        print("ad did unload")
        
    }

    // sharing
    func shareScore() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet.setInitialText("Check out my score in \(Config.gameName)! Can you beat it?")
            let skView = self.view as! SKView
            let postImage: UIImage = getScreenshot(skView.scene!)
            fbSheet.addImage(postImage)
            presentViewController(fbSheet, animated: true, completion: nil)
        }
        else {
            
            let alert = UIAlertController(title: "hello!", message: "Please log in FB in setting", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.Default)
                {(UIAlertACtion) ->Void in}
            alert.addAction(alertAction)
            presentViewController(alert, animated: true){()->Void in}
        }
        
//        let skView = self.view as! SKView
//
//        let postText: String = "Check out my score in \(Config.gameName)! Can you beat it?"
//        let postImage: UIImage = getScreenshot(skView.scene!)
//        let activityItems = [postText, postImage]
//        let activityController = UIActivityViewController(
//            activityItems: activityItems,
//            applicationActivities: nil
//        )
//
//        let controller: UIViewController = skView.scene!.view!.window!.rootViewController!
//
//        controller.presentViewController(
//            activityController,
//            animated: true,
//            completion: nil
//        )
    }

    func getScreenshot(scene: SKScene) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.mainScreen().scale)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
