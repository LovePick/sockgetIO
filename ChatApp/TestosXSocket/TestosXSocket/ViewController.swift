//
//  ViewController.swift
//  TestosXSocket
//
//  Created by T2P mac mini on 12/7/2562 BE.
//  Copyright © 2562 T2P. All rights reserved.
//

import Cocoa
import SocketIO
import WebKit

class ViewController: NSViewController {

    var hasInit:Bool = false
    
    @IBOutlet weak var btConnect: NSButton!
    
    @IBOutlet weak var btJson: NSButton!
    @IBOutlet weak var myWeb: WKWebView!
    
    
    var manager:SocketManager! = nil
    var socket:SocketIOClient! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    override func viewDidAppear() {
        guard let url = URL(string: "http://localhost:3000") else {
            return
        }
        let request:URLRequest = URLRequest(url: url)
        self.myWeb.load(request)
    }
    
    
    
    @IBAction func clickOnConnect(_ sender: Any) {
        
        if(self.hasInit == false){
            
            
            guard let url = URL(string: "http://localhost:3000") else {
                return
            }
            
            
            self.manager = SocketManager(socketURL: url, config: [.log(true), .compress])
            self.socket = self.manager.defaultSocket
            
            socket.on(clientEvent: .connect) {data, ack in
                self.hasInit = true
                print("socket connected")
            }
            
            
            socket.on(clientEvent: .disconnect) { (datas, ack) in
                
                self.hasInit = false
                print("socket disconnect")
            }
            
            socket.on("chat message") {data, ack in
                
                guard let message = data[0] as? String else { return }
                print(message)
                //socket.emit("chat message", with: ["Yes I got it"])
            }
            
            socket.connect()
            
        }
        
    }
    
    
    @IBAction func clickOnJSON(_ sender: Any) {
        
        let myJSON = [
            "name": "bob"
        ]
        
        socket.emit("jsonTest", myJSON)

        
        
    }
    
    
    
}

