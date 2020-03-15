//
//  ViewController.swift
//  DisplayLinkDemo
//
//  Created by Oleg Tsibulevskiy on 15/03/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import UIKit
import DisplayLink

class ViewController: UIViewController
{
    //MARK: - @IBOutlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var displayLink : DisplayLink!
    var displayLink2 : DisplayLink!
    var timer       : DisplayLinkTimer!
    var timerDelay  : Double = 5
    var items       : [Item] = []
    
    //MARK: - Live cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Create and Run DisplayLink
        displayLink = DisplayLink(tickType: .delay(seconds: 1), delegate: self)
        displayLink2 = DisplayLink(tickType: .perFrame, delegate: self)
        displayLink2.startObservation()
        displayLink.startObservation()
        
        //Create and Run Timer
        timer = DisplayLinkTimer(delegate: self)
        timer.startTrack(seconds: timerDelay, infinite: true)

        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

        for i in 0 ..< 20
        {
            items.append(Item(index: "\(i)", dateString: String(describing: Date().timeIntervalSince1970)))
        }

        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

        cell.indexLabel.text = items[indexPath.row].index
        return cell
    }
}

//MARK: - DisplayLinkDelegate
extension ViewController: DisplayLinkDelegate
{
    func tick(displayLink: DisplayLink)
    {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss"

        print("Tick from DisplayLinkDelegate on \(df.string(from: d))")
    }
}

//MARK: - DisplayLinkDelegate
extension ViewController: DisplayLinkTimerDelegate
{
    func timerDidFinish(with type: DisplayLinkTimerFinishType, timer: DisplayLinkTimer)
    {
        print("👍🏻 Timer shooted from \(type)")
        
        tableView.performBatchUpdates( { [unowned self] in

            guard self.items.count > 0 else { timer.stopTrack(); return }
            
            self.items.removeFirst()
            self.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }, completion: nil)
    }

    func timerTick(counter: Double, timer: DisplayLinkTimer)
    {
        timerLabel.text = String(describing: timerDelay - counter)
    }
}


