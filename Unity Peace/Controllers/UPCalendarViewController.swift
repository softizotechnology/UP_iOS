//
//  UPCalendarViewController.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import FSCalendar
class UPCalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var islamicDatelbl: UILabel!
    
    var festivals : [Festival] = []
    var selectedDate : Date?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.eventsTableView.rowHeight = 100.0
        self.eventsTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.updateIslamicDatelbl(date: Date())
        
    }
    
    func updateIslamicDatelbl (date : Date) {
        let dateFor = DateFormatter()
        dateFor.dateStyle = .full
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        dateFor.calendar = hijriCalendar
        
        //dateFor.dateFormat = "dd mmm yyyy"
        self.islamicDatelbl.text = dateFor.string(from: date)
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("Month Changed")
        self.selectedDate = nil
        let cal = Calendar.current
        let date = calendar.currentPage
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let components = DateComponents(year: year, month: month, day: 1)
        let dateToSelect = cal.date(from: components)!
        self.updateIslamicDatelbl(date: dateToSelect)
        self.calendar.select(dateToSelect, scrollToDate: false)
        self.calendar.reloadData()
        self.selectedDate = dateToSelect
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        //make changes here
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        print("Day \(day)")
        if day == 6 {
            cell.titleLabel.textColor = .green
        }
    }
    
    
    func checkDayIsExist(date : Date) -> Bool {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        if currentYear == year && month == currentMonth {
            return true
        }
        return false
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.festivals.count
    }
    
    let CellIdentifier = "FestivalCell"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? FestivalCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FestivalCell", owner: self, options: nil)?[0] as? FestivalCell
            cell?.backgroundColor = .clear
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    @IBAction func nextDate(_ sender: Any) {
        var nextDay : Date!
        if let _ = self.selectedDate {
            nextDay = self.selectedDate!.addingTimeInterval(24 * 60 * 60)
        }else {
            nextDay = Date().addingTimeInterval(24 * 60 * 60)
        }
        self.updateIslamicDatelbl(date: nextDay)
        self.calendar.select(nextDay, scrollToDate: true)
        self.selectedDate = nextDay
        self.calendar.reloadData()

    }
    
    @IBAction func preDate(_ sender: Any) {
        var preDay : Date!
        if let _ = self.selectedDate {
            preDay = self.selectedDate!.addingTimeInterval(-24 * 60 * 60)
            
        }else {
            preDay = Date().addingTimeInterval(-24 * 60 * 60)
        }
        self.updateIslamicDatelbl(date: preDay)
        self.calendar.select(preDay, scrollToDate: true)
        self.selectedDate = preDay
        self.calendar.reloadData()

    }
   
   
}

class Festival: NSObject {
    
}
