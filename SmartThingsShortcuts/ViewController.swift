//
//  ViewController.swift
//  SmartThingsShortcuts
//
//  Created by Steven Vlaminck on 6/8/18.
//  Copyright © 2018 Steven Vlaminck. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    var scenes: [Scene] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        fetchScenes()
    }

    @objc func refresh() {
        INInteraction.deleteAll { error in
            if let error = error {
                💩(error)
            } else {
                🏅("deleted all interactions")
            }
        }
        fetchScenes()
    }
    
    func fetchScenes() {
        SmartThings.API.listScenes { [weak self] response in
            switch response {
            case .success(let scenes):
                🏅("scenes: \(scenes)")
                self?.scenes = scenes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .error(let error):
                💩(error)
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func execute(_ scene: Scene, completion: @escaping (Bool) -> Void) {
        SmartThings.API.executeScene(id: scene.sceneId) { response in
            switch response {
            case .success(_):
                🏅("Executed scene: \(scene.sceneName)")
                
                // create the intent
                let intent = ExecuteSceneIntent()
                intent.sceneName = scene.sceneName
                intent.sceneId = scene.sceneId
                intent.sceneIcon = scene.sceneIcon
                intent.suggestedInvocationPhrase = "Turn on \(scene.sceneName)"
                if let imageData = scene.image?.pngData() {
                    intent.setImage(INImage(imageData: imageData), forParameterNamed: "sceneName")
                }
                🐛(intent)
                
                
                // donate the intent
                let interaction = INInteraction(intent: intent, response: nil)
                interaction.identifier = scene.sceneId
                interaction.donate { error in
                    if let error = error {
                        💩("failed to donate intent; error: \(error)")
                    } else {
                        🏅("successfully donated intent 🎉")
                    }
                }
                
                
                // add it to the siri watch face
                if let shortcut = INShortcut(intent: intent) {
                    🐛(shortcut)
                    let relevantShortcut = INRelevantShortcut(shortcut: shortcut)
                    INRelevantShortcutStore.default.setRelevantShortcuts([relevantShortcut]) { error in
                        if let error = error {
                            💩(error)
                        }
                    }
                } else {
                    💩("no shorcut from intent")
                }

                completion(true)
            case .error(let e):
                💩(e)
                completion(false)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        let scene = scenes[indexPath.item]
        cell.textLabel?.text = scene.sceneName
        cell.imageView?.image = scene.image
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isUserInteractionEnabled = false
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        cell?.accessoryView = indicator
        indicator.startAnimating()

        execute(scenes[indexPath.item]) { success in
            DispatchQueue.main.async {
                cell?.isUserInteractionEnabled = true
                if success {
                    cell?.accessoryView = nil
                    cell?.accessoryType = .checkmark
                } else {
                    let label = UILabel(frame: indicator.frame)
                    label.text = "  !"
                    label.textColor = .red
                    cell?.accessoryView = label
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                cell?.accessoryView = nil
                cell?.accessoryType = .none
            }
        }
    }
}
