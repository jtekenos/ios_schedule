//
//  AppDelegate.swift
//  ios_schedule
//
//  Created by Jess on 2015-11-19.
//  Copyright © 2015 Jess. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts
import RealmSwift
let uiRealm = try! Realm()

func bundlePath(path: String) -> String? {
    let resourcePath = NSBundle.mainBundle().resourcePath as NSString?
    return resourcePath?.stringByAppendingPathComponent(path)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  
        lazy var window: UIWindow? = {
            let win = UIWindow(frame: UIScreen.mainScreen().bounds)
            win.backgroundColor = UIColor.whiteColor()
            win.rootViewController = UINavigationController(rootViewController: ScheduleTableViewController())
            return win
    }()


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    var classes : Results<ClassForum>!
    classes = uiRealm.objects(ClassForum).filter("set = '4R'")
    if classes.count < 1 {
        
        // copy over old data files for migration
        let defaultPath = Realm.Configuration.defaultConfiguration.path!
        let defaultParentPath = (defaultPath as NSString).stringByDeletingLastPathComponent
        print(defaultPath)
        if let v0Path = bundlePath("default1.realm") {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(defaultPath)
                try NSFileManager.defaultManager().copyItemAtPath(v0Path, toPath: defaultPath)
            } catch {}
        }
        
        // define a migration block
        // you can define this inline, but we will reuse this to migrate realm files from multiple versions
        // to the most current version of our data model
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                migration.enumerate(ClassForum.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        // combine name fields into a single field
                        let name = oldObject!["name"] as! String
                        let set = oldObject!["set"] as! String
                        let posts = oldObject!["posts"] as? List<Post>
                    }
                }
                migration.enumerate(Post.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        // combine name fields into a single field
                        let name = oldObject!["name"] as! String
                        let createdAt = oldObject!["createdAt"] as! NSDate
                        let replyList = oldObject!["replyList"] as? List<Reply>
                    }
                }
                migration.enumerate(Reply.className()) { oldObject, newObject in
                    if oldSchemaVersion < 1 {
                        // combine name fields into a single field
                        let name = oldObject!["name"] as! String
                        let createdAt = oldObject!["createdAt"] as! String
                        let author = oldObject!["author"] as? String
                    }
                }
                print("Migration complete.")
                print(oldSchemaVersion)
            }
        }
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: migrationBlock)
        
        // print out all migrated objects in the default realm
        // migration is performed implicitly on Realm access
        //let uiRealm = try! Realm()
        print("Migrated objects in the default Realm: \(try! uiRealm.objects(Reply))")

        
        
        
    }
    
    
    Parse.enableLocalDatastore()
    
    // Initialize Parse.
    Parse.setApplicationId("V8B9K8uoWHxjnVwlRr6esuuYyuJdpCIz33eWpo6V",
        clientKey: "MuXw7T3Szk3VJHycIc2Y2J05d7TGLJodMLm90h54")

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

