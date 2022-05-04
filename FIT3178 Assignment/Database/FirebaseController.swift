//
//  FirebaseController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 1/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var favouritePromptsList: [FavouritePrompt] = []
    var myPromptsList: [MyPrompt] = []
    
    // References to the Firebase Authentication System, Firebase Firestore Database
    var authController: Auth
    var database: Firestore
    var myPromptsRef: CollectionReference?
    var favouritePromptsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    override init(){
        // Configure and initialize each of the Firebase frameworks
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        myPromptsList = [MyPrompt]()
        favouritePromptsList = [FavouritePrompt]()
        super.init()
        
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user
            }
            catch {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
            self.setupMyPromptsListener()
        }

    }
    
    func cleanup() {
        //
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .myPrompts || listener.listenerType == .all {
            listener.onMyPromptsChange(change: .update, myPrompts: myPromptsList)
        }
        
        if listener.listenerType == .favouritePrompts || listener.listenerType == .all {
            listener.onFavouritePromptsChange(change: .update, favouritePrompts: favouritePromptsList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addMyPrompt(text: String) -> MyPrompt {
        let myPrompt = MyPrompt()
        myPrompt.text = text
        
        do {
            if let myPromptRef = try myPromptsRef?.addDocument(from: myPrompt) {
                myPrompt.id = myPromptRef.documentID
            }
        } catch {
            print("Failed to serialize my Prompt")
        }
        return myPrompt
    }
    
    func deleteMyPrompt(myPrompt: MyPrompt) {
        if let myPromptID = myPrompt.id {
            myPromptsRef?.document(myPromptID).delete()
        }
    }
    
    func addFavouritePrompt(imageURL: String, text: String) -> FavouritePrompt {
        let favouritePrompt = FavouritePrompt()
        favouritePrompt.imageURL = imageURL
        favouritePrompt.text = text
        do {
            if let favouritePromptRef = try favouritePromptsRef?.addDocument(from: favouritePrompt) {
                favouritePrompt.id = favouritePromptRef.documentID
            }
        } catch {
            print("Failed to serialize favourite prompts")
        }
        return favouritePrompt
    }
    
    func deleteFavouritePromp(favouritePrompt: FavouritePrompt) {
        if let favouritePromptID = favouritePrompt.id {
            favouritePromptsRef?.document(favouritePromptID).delete()
        }
    }
    
    func createNewAccount(email: String, password: String) {
        //
    }
    
    func signInWithAccount(email: String, password: String) {
        //
    }
    
    func setupMyPromptsListener() {
        myPromptsRef = database.collection("myPrompts")
        myPromptsRef?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseMyPromptsSnapshot(snapshot: querySnapshot)
        }
        if self.favouritePromptsRef == nil {
            self.setupFavouritePromptsListener()
        }
    }
    
    func setupFavouritePromptsListener() {
        favouritePromptsRef = database.collection("favouritePrompts")
        favouritePromptsRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching teams: \(error!)")
                return
            }
            self.parseFavouritePromptsSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseMyPromptsSnapshot(snapshot: QuerySnapshot){
        print("Snapshot count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedMyPrompt: MyPrompt?
            
            do {
                print(change.document.data())
                parsedMyPrompt = try change.document.data(as: MyPrompt.self)
            } catch let error {
                print("Unable to decode hero. Is the hero malformed?")
                print(error.localizedDescription)
                return
            }
            
            guard let myPrompt = parsedMyPrompt else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                print("Change.newIndex: \(change.newIndex)")
                myPromptsList.insert(myPrompt, at: Int(change.newIndex))
            } else if change.type == .modified {
                myPromptsList[Int(change.oldIndex)] = myPrompt
            } else if change.type == .removed {
                myPromptsList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.myPrompts || listener.listenerType == ListenerType.all {
                listener.onMyPromptsChange(change: .update, myPrompts: myPromptsList)
            }
        }
    }
    
    func parseFavouritePromptsSnapshot(snapshot: QuerySnapshot) {
        print("Snapshot count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedFavouritePrompt: FavouritePrompt?
            
            do {
                print(change.document.data())
                parsedFavouritePrompt = try change.document.data(as: FavouritePrompt.self)
            } catch let error {
                print("Unable to decode hero. Is the hero malformed?")
                print(error.localizedDescription)
                return
            }
            
            guard let favouritePrompt = parsedFavouritePrompt else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                print("Change.newIndex: \(change.newIndex)")
                favouritePromptsList.insert(favouritePrompt, at: Int(change.newIndex))
            } else if change.type == .modified {
                favouritePromptsList[Int(change.oldIndex)] = favouritePrompt
            } else if change.type == .removed {
                favouritePromptsList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.favouritePrompts || listener.listenerType == ListenerType.all {
                listener.onFavouritePromptsChange(change: .update, favouritePrompts: favouritePromptsList)
            }
        }
    }
    
    
}