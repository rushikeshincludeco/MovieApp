//
//  mainTableViewController.swift
//  MovieApp
//
//  Created by include tech. on 02/11/16.
//  Copyright © 2016 include tech. All rights reserved.
//

import UIKit

class Movie {
	var title = ""
	var image = ""
	var rating = 0
	var releaseYear = 0
	var genre : Array<String> = []
	
}

class ImageLoadingWithCache {
	
	var imageCache = [String:UIImage]()
	
	func getImage(url: String, imageView: UIImageView, defaultImage: String) {
		if let img = imageCache[url] {
			imageView.image = img
		} else {
			let request: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
			let mainQueue = NSOperationQueue.mainQueue()
			
			NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
				if error == nil {
					let image = UIImage(data: data!)
					self.imageCache[url] = image
					
					dispatch_async(dispatch_get_main_queue(), {
						imageView.image = image
					})
				}
				else {
					imageView.image = UIImage(named: defaultImage)
				}
			})
		}
	}
}

class mainTableViewController: UITableViewController {
	
	var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.registerClass(CustomeTableViewCell.self, forCellReuseIdentifier: "CustomeTableViewCell")
		tableView.delegate = self
		tableView.dataSource = self

		
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: configuration)
		let apiKey = "http://api.androidhive.info/json/movies.json"
		
		
		if let url = NSURL(string: apiKey) {
			// Spawning Task To Retrieve JSON Data
			session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
				// Checking For Error
				if error != nil {
					print("The error is: \(error!)")
					return
				} else if let jsonData = data {
					do {
						let parsedJSON  = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers) as! NSArray
//						guard let results = parsedJSON["results"] as? [String:AnyObject] else { return }
						for result in parsedJSON {
							let movie = Movie()
							movie.title = result["title"] as! String
							movie.image = result["image"] as! String
							movie.rating = result["rating"] as! Int
							movie.releaseYear = result["releaseYear"] as! Int
							movie.genre = result["genre"] as! Array
							self.movies.append(movie)
						}
						dispatch_async(dispatch_get_main_queue()) {
							self.tableView.reloadData()
						}
						
					} catch let error as NSError {
						print(error)
					}
				}
			}).resume()
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
			}
		}
		dispatch_async(dispatch_get_main_queue()) {
			self.tableView.reloadData()
		}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomeTableViewCell", forIndexPath: indexPath) as! CustomeTableViewCell

        // Configure the cell...
		cell.backgroundColor = UIColor.blackColor()
		
		if let movie : Movie =  movies[indexPath.row] {
		
			cell.movieTitle.text = movie.title
			//		let cache = ImageLoadingWithCache()
			//		cache.getImage(movie.image, imageView: cell.movieImage, defaultImage: "")
			cell.movieRatings.text = movie.rating.description
			cell.movieReleaseYear.text = movie.releaseYear.description
			let genre = movie.genre.joinWithSeparator(" , ")
			cell.movieGenre.text = genre
		}
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
