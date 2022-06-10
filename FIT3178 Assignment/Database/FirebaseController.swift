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
    var favouritePromptsList: [Prompt] = []
    var myPromptsList: [Prompt] = []
    var postedStoriesList: [Story] = []
    var friendList: [User] = []
    var friendRequestList: [User] = []
    var allUsersList: [User] = []
    var friendPostedStoriesList: [Story] = []
 
    // References to the Firebase Authentication System, Firebase Firestore Database
    var authController: Auth
    var database: Firestore
    var myPromptsRef: CollectionReference?
    var favouritePromptsRef: CollectionReference?
    var postedStoriesRef: CollectionReference?
    var usersRefs: CollectionReference?
    var friendsRef: CollectionReference?
    var friendRequestRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    // Current user object mapped
    var signedInUser: User
    
    override init(){
        // Configure and initialize each of the Firebase frameworks
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        signedInUser = User()
        myPromptsList = [Prompt]()
        favouritePromptsList = [Prompt]()
        postedStoriesList = [Story]()
        friendList = [User]()
        friendRequestList = [User]()
        allUsersList = [User]()
        friendPostedStoriesList = [Story]()
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
        
        if listener.listenerType == .friendRequests || listener.listenerType == .all {
            listener.onFriendRequestsChange(change: .update, friendRequests: friendRequestList)
        }
        
        if listener.listenerType == .allUsers || listener.listenerType == .all {
            listener.onAllUsersChange(change: .update, allUsers: allUsersList)
        }
        
        if listener.listenerType == .friendPostedStories || listener.listenerType == .all {
            listener.onFriendPostedStoriesChange(change: .update, friendPostedStories: friendPostedStoriesList)
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
        story.datePosted = Date()
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
    
    func addFriendToUser(friend: User) -> User {
        //let friend = User()
        //friend.uid = uid
        //friend.username = username
        usersRefs = database.collection("users")
        let friendListRef = usersRefs?.document(currentUser?.uid ?? "").collection("friends")
        let _ = friendListRef?.document(friend.uid ?? "").setData(["uid": friend.uid ?? "", "username": friend.username ?? ""]) {err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        /*
        // Add all friend's posted story to user's friendsPostedStories
        let friendPostedStoriesRef = usersRefs?.document(friend.uid ?? "").collection("postedStories")
        friendPostedStoriesRef?.addSnapshotListener{ (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            //self.parsePostedStoriesSnapShot(snapshot: querySnapshot)
            querySnapshot.documents.forEach({
                
            })
        }*/
        
        return friend
    }
    
    func deleteFriendFromUser(user: User) {
        usersRefs = database.collection("users")
        let friendListRef = usersRefs?.document(currentUser?.uid ?? "").collection("friends")
        if let friendID = user.id {
            friendListRef?.document(friendID).delete()
        }
    }
    
    func addUserToFriend(friend: User) -> User {
        usersRefs = database.collection("users")
        let friendListRef = usersRefs?.document(friend.uid ?? "").collection("friends")
        let _ = friendListRef?.document(signedInUser.uid ?? "").setData(["uid": signedInUser.uid ?? "", "username": signedInUser.username ?? ""]) {err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        /*
        let friendPostedStories
        // When you add friend to user, also add their posted stories to friendsPostedStories
        postedStoriesRef = usersRefs?.document(friend?.uid ?? "").collection("postedStories")
        postedStoriesRef?.addSnapshotListener{ (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parsePostedStoriesSnapShot(snapshot: querySnapshot)
        }*/
        
        return friend
    }
    
    
    // Add current user to friend's request list
    func addUserToFriendRequest(friend: User) -> User {
        // Create current user object
        let currentUser = User()
        currentUser.uid = self.signedInUser.uid
        currentUser.username = self.signedInUser.username
        // Get reference to the other user's friend request list
        usersRefs = database.collection("users")
        let userFriendRequestRef = usersRefs?.document(friend.uid ?? "").collection("friendRequests")
        let _ = userFriendRequestRef?.document(currentUser.uid ?? "").setData(["uid": currentUser.uid ?? "", "username": currentUser.username ?? ""]) {err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        return friend
    }
    
    // delete friend from current user's request list
    func deleteUserFromFriendRequest(friend: User) {
        usersRefs = database.collection("users")
        let userFriendRequestRef = usersRefs?.document(currentUser?.uid ?? "").collection("friendRequests")
        if let friendID = friend.uid {
            userFriendRequestRef?.document(friendID).delete()
        }
    }
    
    func createNewAccount(email: String, password: String, username: String) {
        usersRefs = database.collection("users")
        authController.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
            self.currentUser = authResult?.user
            self.signedInUser.uid = self.currentUser?.uid
            self.signedInUser.username = username
            let _ = self.usersRefs?.document((self.currentUser?.uid)!).setData(["uid": authResult?.user.uid ?? "", "username": username]) {err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            self.setupAllUsersListener()
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
            
            // Get the current user from db
            let docRef = self?.usersRefs?.document(self?.currentUser?.uid ?? "")
            docRef?.getDocument{ (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    print("Document data: \(String(describing: dataDescription))")
                    
                    self?.signedInUser.uid = dataDescription?["uid"] as? String
                    self?.signedInUser.username = dataDescription?["username"] as? String
                } else {
                    print("Document does not exist")
                }
            }
            print("Current user signed in: \(self!.currentUser?.uid ?? "")")
            self?.setupAllUsersListener()
            self?.setupMyPromptsListener()
        }
    }
    
    func userSignOut() {
        do {
            try authController.signOut()
        } catch {
            print("Already logged out!")
        }
    }
    
    func getCurrentUser() -> User {
        return self.signedInUser
    }
    
    func setupAllUsersListener() {
        usersRefs?.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseAllUsersSnapshot(snapshot: querySnapshot)
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
        if self.friendRequestRef == nil {
            self.setupFriendRequestsListener()
        }
    }
    
    func setupFriendRequestsListener() {
        friendRequestRef = usersRefs?.document(currentUser?.uid ?? "").collection("friendRequests")
        friendRequestRef?.addSnapshotListener{ (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseFriendRequestsSnapshot(snapshot: querySnapshot)
        }
    }
    
    func setupFriendPostedStoriesListener(friend: User) {
        let postedFriendStoriesRef = usersRefs?.document(friend.uid ?? "").collection("postedStories")
        postedFriendStoriesRef?.addSnapshotListener{ (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseFriendPostedStoriesSnapShot(snapshot: querySnapshot)
        }
    }
    
    func parseFriendPostedStoriesSnapShot(snapshot: QuerySnapshot) {
        friendPostedStoriesList.removeAll()
        print("Snapshot count for Posted Stories: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedPostedStory: Story?
            
            do {
                print("Posted story: \(change.document.data())")
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
                friendPostedStoriesList.insert(postedStory, at: Int(change.newIndex))
            } else if change.type == .modified {
                friendPostedStoriesList[Int(change.oldIndex)] = postedStory
            } else if change.type == .removed {
                friendPostedStoriesList.remove(at: Int(change.oldIndex))
            }
        }
        
        friendPostedStoriesList.sort {$0.datePosted ?? Date() > $1.datePosted ?? Date()}
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.friendPostedStories || listener.listenerType == ListenerType.all {
                listener.onFriendPostedStoriesChange(change: .update, friendPostedStories: friendPostedStoriesList)
            }
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
        print("Snapshot count for Posted Stories: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedPostedStory: Story?
            
            do {
                print("Posted story: \(change.document.data())")
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
        
        postedStoriesList.sort {$0.datePosted ?? Date() > $1.datePosted ?? Date()}
        
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
                print(error)
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
    
    func parseAllUsersSnapshot(snapshot: QuerySnapshot) {
        print("Snapshot count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedUser: User?
            
            do {
                print(change.document.data())
                parsedUser = try change.document.data(as: User.self)
            } catch let error {
                print("Unable to decode user. Is the user malformed?")
                print(error)
                return
            }
            
            guard let user = parsedUser else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                print("Change.newIndex: \(change.newIndex)")
                allUsersList.insert(user, at: Int(change.newIndex))
            } else if change.type == .modified {
                allUsersList[Int(change.oldIndex)] = user
            } else if change.type == .removed {
                allUsersList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.allUsers || listener.listenerType == ListenerType.all {
                listener.onAllUsersChange(change: .update, allUsers: allUsersList)
            }
        }
    }
    
    func parseFriendRequestsSnapshot(snapshot: QuerySnapshot) {
        print("Snapshot Friend Requests count: \(snapshot.count)")
        snapshot.documentChanges.forEach { (change) in
            var parsedFriendRequestUser: User?
            
            do {
                print("Friend request: \(change.document.data())")
                parsedFriendRequestUser = try change.document.data(as: User.self)
            } catch let error {
                print("Unable to decode user. Is the user malformed?")
                print(error)
                return
            }
            
            guard let user = parsedFriendRequestUser else {
                print("Document doesn't exist")
                return;
            }
            if change.type == .added {
                print("Change.newIndex: \(change.newIndex)")
                friendRequestList.insert(user, at: Int(change.newIndex))
            } else if change.type == .modified {
                friendRequestList[Int(change.oldIndex)] = user
            } else if change.type == .removed {
                friendRequestList.remove(at: Int(change.oldIndex))
            }
        }
        
        listeners.invoke { (listener) in
            if listener.listenerType == ListenerType.friendRequests || listener.listenerType == ListenerType.all {
                listener.onFriendRequestsChange(change: .update, friendRequests: friendRequestList)
            }
        }
    }
}
