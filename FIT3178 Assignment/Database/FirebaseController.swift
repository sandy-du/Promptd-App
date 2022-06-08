//
//  FirebaseController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 1/5/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import simd

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var favouritePromptsList: [Prompt] = []
    var myPromptsList: [Prompt] = []
    var postedStoriesList: [Story] = []
    var friendList: [User] = []
    var allUsersList: [User] = []
    
    // References to the Firebase Authentication System, Firebase Firestore Database
    var authController: Auth
    var database: Firestore
    var myPromptsRef: CollectionReference?
    var favouritePromptsRef: CollectionReference?
    var postedStoriesRef: CollectionReference?
    var usersRefs: CollectionReference?
    var friendsRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    override init(){
        // Configure and initialize each of the Firebase frameworks
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        myPromptsList = [Prompt]()
        favouritePromptsList = [Prompt]()
        postedStoriesList = [Story]()
        friendList = [User]()
        allUsersList = [User]()
        super.init()
        
        /*
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user
            }
            catch {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
            self.setupMyPromptsListener()
        }*/

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
        
        if listener.listenerType == .postedStories || listener.listenerType == .all {
            listener.onPostedStoriesChange(change: .update, postedStories: postedStoriesList)
        }
        
        if listener.listenerType == .postedStories || listener.listenerType == .all {
            listener.onPostedStoriesChange(change: .update, postedStories: postedStoriesList)
        }
        
        if listener.listenerType == .friends || listener.listenerType == .all {
            listener.onFriendsChange(change: .update, friends: friendList)
        }
        
        if listener.listenerType == .allUsers || listener.listenerType == .all {
            listener.onFriendsChange(change: .update, friends: friendList)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func addMyPrompt(text: String) -> Prompt {
        let myPrompt = Prompt()
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
    
    func deleteMyPrompt(myPrompt: Prompt) {
        if let myPromptID = myPrompt.id {
            myPromptsRef?.document(myPromptID).delete()
        }
    }
    
    func addFavouritePrompt(imageURL: String, text: String) -> Prompt {
        let favouritePrompt = Prompt()
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
    
    func deleteFavouritePrompt(favouritePrompt: Prompt) {
        if let favouritePromptID = favouritePrompt.id {
            favouritePromptsRef?.document(favouritePromptID).delete()
        }
    } 
    
    func addStoryToUser(prompt: Prompt, text: String) -> Story {
        let story = Story()
        story.text = text
        story.prompt = prompt
        usersRefs = database.collection("users")
        let storiesRefs = usersRefs?.document(currentUser?.uid ?? "").collection("postedStories")
        
        do {
            if let storyRef = try storiesRefs?.addDocument(from: story){
                story.id = storyRef.documentID
            }
        } catch {
            print("Failed to serialize stories")
        }
        return story
    }
    
    func deleteStoryFromUser(story: Story) {
        usersRefs = database.collection("users")
        let storiesRefs = usersRefs?.document(currentUser?.uid ?? "").collection("postedStories")
        
        if let storyID = story.id {
            storiesRefs?.document(storyID).delete()
        }
    }
    
    func addFriendToUser(uid: String, username: String) -> User {
        let friend = User()
        friend.uid = uid
        friend.username = username
        usersRefs = database.collection("users")
        let friendListRef = usersRefs?.document(currentUser?.uid ?? "").collection("friends")
        do {
            if let friendRef = try friendListRef?.addDocument(from: friend){
                friend.id = friendRef.documentID
            }
        } catch {
            print("Failed to serialize friends")
        }
        return friend
    }
    
    func deleteFriendFromUser(user: User) {
        usersRefs = database.collection("users")
        let friendListRef = usersRefs?.document(currentUser?.uid ?? "").collection("friends")
        if let friendID = user.id {
            friendListRef?.document(friendID).delete()
        }
    }
    
    func createNewAccount(email: String, password: String) {
        usersRefs = database.collection("users")
        authController.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
            self.currentUser = authResult?.user
            let _ = self.usersRefs?.document((self.currentUser?.uid)!).setData(["uid": authResult?.user.uid ?? ""]) {err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            self.setupMyPromptsListener()
        }
    }
    
    func signInWithAccount(email: String, password: String) {
        usersRefs = database.collection("users")
        authController.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
            self!.currentUser = authResult?.user
            print("Current user signed in: \(self!.currentUser?.uid ?? "")")
            self?.setupMyPromptsListener()
        }
    }
    
    func setupMyPromptsListener() {
        myPromptsRef = usersRefs?.document(currentUser?.uid ?? "").collection("myPrompts")
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
        favouritePromptsRef = usersRefs?.document(currentUser?.uid ?? "").collection("favouritePrompts")
        favouritePromptsRef?.addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Error fetching teams: \(error!)")
                return
            }
            self.parseFavouritePromptsSnapshot(snapshot: querySnapshot)
        }
        if self.postedStoriesRef == nil {
            self.setupPostedStoriesListener()
        }
    }
    
    func setupPostedStoriesListener(){
        postedStoriesRef = usersRefs?.document(currentUser?.uid ?? "").collection("postedStories")
        postedStoriesRef?.addSnapshotListener{ (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parsePostedStoriesSnapShot(snapshot: querySnapshot)
        }
        if self.friendsRef == nil {
            self.setupFriendsListener()
        }
    }
    
    func setupFriendsListener() {
        friendsRef = usersRefs?.document(currentUser?.uid ?? "").collection("friends")
        friendsRef?.addSnapshotListener{ (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseFriendsSnapShot(snapshot: querySnapshot)
        }
    }
    
    func parseMyPromptsSnapshot(snapshot: QuerySnapshot){
        print("Snapshot count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedMyPrompt: Prompt?
            
            do {
                print(change.document.data())
                parsedMyPrompt = try change.document.data(as: Prompt.self)
            } catch let error {
                print("Unable to decode prompt. Is the prompt malformed?")
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
            var parsedFavouritePrompt: Prompt?
            
            do {
                print(change.document.data())
                parsedFavouritePrompt = try change.document.data(as: Prompt.self)
            } catch let error {
                print("Unable to decode prompt. Is the prompt malformed?")
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
    
    func parsePostedStoriesSnapShot(snapshot: QuerySnapshot) {
        print("Snapshot count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedPostedStory: Story?
            
            do {
                print(change.document.data())
                parsedPostedStory = try change.document.data(as: Story.self)
            } catch let error {
                print("Unable to decode story. Is the story malformed?")
                print(error.localizedDescription)
                return
            }
            
            guard let postedStory = parsedPostedStory else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                print("Change.newIndex: \(change.newIndex)")
                postedStoriesList.insert(postedStory, at: Int(change.newIndex))
            } else if change.type == .modified {
                postedStoriesList[Int(change.oldIndex)] = postedStory
            } else if change.type == .removed {
                postedStoriesList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.postedStories || listener.listenerType == ListenerType.all {
                listener.onPostedStoriesChange(change: .update, postedStories: postedStoriesList)
            }
        }
    }
    
    func parseFriendsSnapShot(snapshot: QuerySnapshot) {
        print("Snapshot count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedFriend: User?
            
            do {
                print(change.document.data())
                parsedFriend = try change.document.data(as: User.self)
            } catch let error {
                print("Unable to decode friend. Is the friend malformed?")
                print(error.localizedDescription)
                return
            }
            
            guard let friend = parsedFriend else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                print("Change.newIndex: \(change.newIndex)")
                friendList.insert(friend, at: Int(change.newIndex))
            } else if change.type == .modified {
                friendList[Int(change.oldIndex)] = friend
            } else if change.type == .removed {
                friendList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.friends || listener.listenerType == ListenerType.all {
                listener.onFriendsChange(change: .update, friends: friendList)
            }
        }
    }
}
