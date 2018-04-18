//
//  GameViewController.swift
//  Chasing Love
//
//  Created by Nhat Tran on 1/22/16.
//  Copyright © 2016 Nhat Tran. All rights reserved.
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
    
    override func loadView(){
        self.view = SKView(frame: UIScreen.main.applicationFrame)
    }

    override func viewDidLoad() {
        if Config.soundsEnabled {
            setupBackgroundMusic()
        }

        if Config.gameCenterEnabled {
            authenticateLocalPlayer()
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showLeaderboard), name: NSNotification.Name(rawValue: "showLeaderboard"), object: nil)
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
            NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.showAdMobInterstitialAd), name: NSNotification.Name(rawValue: "showAdMobInterstitialAd"), object: nil)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.shareScore), name: NSNotification.Name(rawValue: "shareScore"), object: nil)

        let scene = MenuScene()
        scene.scaleMode = .aspectFill
        scene.size = Config.sceneSize

        //self.view = SKView(frame: UIScreen.mainScreen().applicationFrame)
        let skView = self.view as! SKView
        //let skView = self.view

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

        let url: URL = URL(fileURLWithPath: Bundle.main.path(forResource: Config.backgroundMusicFileName, ofType: "mp3")!)
        do {
            try player = AVAudioPlayer(contentsOf: url)
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
                self.present(viewController!, animated: true, completion: nil)
            } else {
                print("(GameCenter) Player authenticated: \(GKLocalPlayer.localPlayer().isAuthenticated)")
            }
        }
    }
    
    func showLeaderboard() {
        let gcViewController: GKGameCenterViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        gcViewController.viewState = GKGameCenterViewControllerState.leaderboards
        
        // Remember to replace "Best Score" with your Leaderboard ID (which you have created in iTunes Connect)
        gcViewController.leaderboardIdentifier = Config.remoteLeaderboardID
        self.show(gcViewController, sender: self)
        self.navigationController?.pushViewController(gcViewController, animated: true)
        // self.presentViewController(gcViewController, animated: true, completion: nil)
    }

//    func showLeaderboard() {
////        let localPlayer = GKLocalPlayer.localPlayer()
////        
////        if (localPlayer.authenticated)
////        {
//        let viewController: GKGameCenterViewController = GKGameCenterViewController()
//        viewController.gameCenterDelegate = self
//        viewController.viewState = GKGameCenterViewControllerState.Leaderboards
//        viewController.leaderboardIdentifier = Config.remoteLeaderboardID
//        self.presentViewController(viewController, animated: true, completion: nil)
//        
////        else
////        {
////            authenticateLocalPlayer()
////        }
//    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    // iAd & admob
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        bannerView.isHidden = false
    }

    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        bannerView.isHidden = true
    }

    func setupAdmobAd() {
        print("setting app admob")

        let adHeight = CGSizeFromGADAdSize(kGADAdSizeSmartBannerLandscape).height

        adMobBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape,
            origin: CGPoint(x: view.frame.minX, y: view.frame.maxY - adHeight))

        adMobBannerView.adUnitID = Config.admobBannerId
        adMobBannerView.delegate = self
        adMobBannerView.rootViewController = self
        view.addSubview(adMobBannerView)

        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        adMobBannerView.load(request)
    }

//    func setupiAd() {
//        print("setting app iad")
//        bannerView = ADBannerView(adType: .Banner)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        bannerView.delegate = self
//        bannerView.hidden = true
//        view.addSubview(bannerView)
//        let viewsDictionary = ["bannerView": bannerView]
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
//
//    }

    // MARK: - adMob INTERSTITIAL ADS
    func createAndLoadAdMobInterstitial() {
        adMobInterstitial = GADInterstitial(adUnitID: Config.admobInterstitialId)
        adMobInterstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID ]
        adMobInterstitial.load(request)
    }

    func showAdMobInterstitialAd(){
        print("received showAdMobInterstitialAd notification")
        if adMobInterstitial.isReady {
            adMobInterstitial.present(fromRootViewController: self)
        }
    }

    /// Called when an interstitial ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial!) {
        print("interstitialDidReceiveAd")
    }

    /// Called when an interstitial ad request failed.
    func interstitial(_ ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Called just before presenting an interstitial.
    func interstitialWillPresentScreen(_ ad: GADInterstitial!) {
        print("interstitialWillPresentScreen")
    }

    /// Called before the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial!) {
        print("interstitialWillDismissScreen")
    }

    /// Called just after dismissing an interstitial and it has animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        createAndLoadAdMobInterstitial()
    }


    /// Called just before the application will background or terminate because the user clicked on an
    /// ad that will launch another app (such as the App Store).
    func interstitialWillLeaveApplication(_ ad: GADInterstitial!) {
        print("interstitialWillLeaveApplication")
    }


    // MARK: -  iAD INTERSTITIAL ADS
    func showInterstitialAd() {
        print("received showInterstitialAd request")
        interstitialAd = ADInterstitialAd()
        interstitialAd.delegate = self
    }

    func interstitialAdWillLoad(_ interstitialAd: ADInterstitialAd!) {

    }

    func interstitialAdDidLoad(_ interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        view.addSubview(interstitialAdView)
        interstitialAd.present(in: interstitialAdView)
        UIViewController.prepareInterstitialAds()
        print("ad did load")

    }

    func interstitialAdActionDidFinish(_ interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        print("ad finished")
    }

    func interstitialAdActionShouldBegin(_ interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }

    func interstitialAd(_ interstitialAd: ADInterstitialAd!, didFailWithError error: Error!) {
        print("ad failed with error")
    }

    func interstitialAdDidUnload(_ interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        print("ad did unload")
        
    }

    // sharing
    func shareScore() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet?.setInitialText("Check out my score in \(Config.gameName)! Can you beat it?")
            let skView = self.view as! SKView
            let postImage: UIImage = getScreenshot(skView.scene!)
            fbSheet?.add(postImage)
            present(fbSheet!, animated: true, completion: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Share Your Score on Facebook", message: "Please log in Facebook in HomeScreen->Setting", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title:"ok", style:UIAlertActionStyle.default)
                {(UIAlertACtion) ->Void in}
            alert.addAction(alertAction)
            present(alert, animated: true){()->Void in}
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

    func getScreenshot(_ scene: SKScene) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
