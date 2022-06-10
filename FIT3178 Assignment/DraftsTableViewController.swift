//
//  DraftsTableViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 25/5/2022.
//

import UIKit

class DraftsTableViewController: UITableViewController, CoreDataListener {

    let CELL_DRAFT = "draftCell"
    var allDrafts: [StoryDraft] = []
    var listenerType = CoreDataListenerType.draft
    weak var coreDataController: CoreDataProtocol?
    var selectedDraft: StoryDraft?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        coreDataController = appDelegate?.coreDataController

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDrafts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let draftCell = tableView.dequeueReusableCell(withIdentifier: CELL_DRAFT, for: indexPath)
        var content = draftCell.defaultContentConfiguration()
        let draft = allDrafts[indexPath.row]
        content.text = draft.promptText
        content.secondaryText = draft.draftText
        draftCell.contentConfiguration = content
        return draftCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDraft = allDrafts[indexPath.row]
        performSegue(withIdentifier: "showDraftWritingScreenSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let draft = allDrafts[indexPath.row]
            coreDataController?.deleteDraft(draft: draft)
        }
    }
    
    func onDraftChange(change: CoreDataDatabaseChange, drafts: [StoryDraft]) {
        allDrafts = drafts
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coreDataController?.removeListener(listener: self)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDraftWritingScreenSegue" {
            let destination = segue.destination as! WritingScreenViewController
            let currentPrompt = Prompt()
            currentPrompt.text = selectedDraft?.promptText
            currentPrompt.imageURL = selectedDraft?.promptImage
            destination.currentPrompt = currentPrompt
            destination.currentStoryText = selectedDraft?.draftText
            destination.currentScreen = "Draft"
            destination.currentDraft = selectedDraft
        }
    }
}
