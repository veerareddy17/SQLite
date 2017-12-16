//
//  EventTableViewController.swift
//  EventManager
//
//  Created by vera on 23/11/17.
//  Copyright © 2017 vera. All rights reserved.
//

import UIKit
import SQLite
import SQLite3

class EventTableViewController: UIViewController {
    var eventDetails = [EventDetails]()
    var dateFormatter:DateFormatter!
    var isSearching : Bool = false
    var searchResults = [EventDetails]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var myEventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY 'Time' hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        searchController.dimsBackgroundDuringPresentation = false
        myEventTableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventDetails.removeAll()
        if let allEvents: AnySequence<Row> = Event.shared.queryAll() {
            for eachEvent in allEvents {
                Event.shared.toString(event: eachEvent)
                let eventDet = Event.shared.getEventDetails(event: eachEvent)
                eventDetails.append(EventDetails(eventName: eventDet.0, eventDate: eventDet.1))
            }
        }
        myEventTableView.reloadData()
    }
}

extension EventTableViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchResults.count
        }
        return eventDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath)
        
        if isFiltering() {
            cell.textLabel?.text = searchResults[indexPath.row].eventName
            cell.detailTextLabel?.text =  dateFormatter.string(from: searchResults[indexPath.row].eventDate!)
        } else {
            cell.textLabel?.text = eventDetails[indexPath.row].eventName
            cell.detailTextLabel?.text =  dateFormatter.string(from: eventDetails[indexPath.row].eventDate!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension EventTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchResults = eventDetails.filter { (event:EventDetails) in
                return event.eventName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || (dateFormatter.string(from:event.eventDate!).contains(searchText))
            }
        } else {
            searchResults = eventDetails
        }
        myEventTableView.reloadData()
    }
}
