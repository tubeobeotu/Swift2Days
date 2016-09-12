//
//  SearchViewControllerAlamofire.swift
//  Pods
//
//  Created by Vinh The on 9/11/16.
//
//
import UIKit
import MediaPlayer

class SearchViewControllerAlamofire: UIViewController {
    
    var searchRequest : Request?
    
    var searchResults = [Track]()
    
    var activeDownloads = [String: Download]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(SearchViewControllerAlamofire.dismissKeyboard))
        return recognizer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    //MARK: Start, Pause, Resume, Stop downloading
    func startDownload(track : Track) {
        if let urlString = track.previewUrl, url = NSURL(string: urlString){
            
            let download = Download(url: urlString)
            
            download.downloadRequest = Alamofire.download(.GET, url, destination: { (temporaryURL, response) -> NSURL in
                
                self.saveFile(download, temporaryURL: temporaryURL)
                
                return temporaryURL
            }).progress({ (byteRead, totalByteRead, totalByteExpectedToRead) in
                print(totalByteRead, totalByteExpectedToRead)
                
                self.downloadProgress(download, totalByteRead: totalByteRead, totalByteExpectedToRead: totalByteExpectedToRead)
            })
            
            download.downloadRequest!.resume()
            
            download.isDownloading = true
            
            activeDownloads[download.url] = download
        }
    }
    
    func pauseDownload(track: Track) {
        if let urlString = track.previewUrl,
            download = activeDownloads[urlString] {
            if(download.isDownloading) {
                download.downloadRequest?.cancel()
                
                download.downloadRequest?.response(completionHandler: { (_, _, data, error) in
                    if let error = error {
                        if error.code == NSURLErrorCancelled {
                            download.resumeData = data! as NSData
                        } else {
                            print("Failed to download file: \(error)")
                        }
                    } else {
                        print("Successfully downloaded file:")
                    }
                })
                download.isDownloading = false
            }
        }
    }
    
    func resumeDownload(track: Track) {
        if let urlString = track.previewUrl,
            download = activeDownloads[urlString] {
            if let resumeData = download.resumeData {
                
                download.downloadRequest = Alamofire.download(resumeData: resumeData, destination: { (temporaryURL, response) -> NSURL in
                    
                    self.saveFile(download, temporaryURL: temporaryURL)
                    
                    return temporaryURL
                }).progress({ (byteRead, totalByteRead, totalByteExpectedToRead) in
                    print(totalByteRead, totalByteExpectedToRead)
                    
                    self.downloadProgress(download, totalByteRead: totalByteRead, totalByteExpectedToRead: totalByteExpectedToRead)
                    
                })
                
                
                download.isDownloading = true
            } else if let url = NSURL(string: download.url) {
                
                //không thể resume khi resumeData = nil
                
                download.isDownloading = true
            }
        }
    }
    
    func cancelDownload(track: Track) {
        if let urlString = track.previewUrl,
            download = activeDownloads[urlString] {
            download.downloadRequest?.cancel()
            activeDownloads[urlString] = nil
        }
    }
    
    //MARK: Helper func
    func downloadProgress(download : Download, totalByteRead : Int64, totalByteExpectedToRead : Int64 ) {
        //Kiểm tra url của download request có tồn tại hay không -> Lấy ra đối tượng download trong activeDownload theo URL
        
        if let downloadUrl = download.downloadRequest?.request!.URL?.absoluteString,
            download = self.activeDownloads[downloadUrl] {
            
            //Set progress của đối tượng đang được download
            download.progress = Float(totalByteRead)/Float(totalByteExpectedToRead)
            
            let totalSize = NSByteCountFormatter.stringFromByteCount(totalByteExpectedToRead, countStyle: NSByteCountFormatterCountStyle.Binary)
            
            if let trackIndex = self.trackIndexForDownloadTask(download.downloadRequest), let trackCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: trackIndex, inSection: 0)) as? TrackCell {
                
                dispatch_async(dispatch_get_main_queue(), {
                    trackCell.progressView.progress = download.progress
                    trackCell.progressLabel.text =  String(format: "%.1f%% of %@",  download.progress * 100, totalSize)
                })
                
            }
        }
    }
    
    func saveFile(download : Download, temporaryURL : NSURL) {
        if let originalURL = download.downloadRequest?.request?.URL?.absoluteString,
            destinationURL = self.localFilePathForUrl(originalURL) {
            
            print(destinationURL)
            
            let fileManager = NSFileManager.defaultManager()
            do {
                try fileManager.removeItemAtURL(destinationURL)
            } catch {
            }
            do {
                try fileManager.copyItemAtURL(temporaryURL, toURL: destinationURL)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        if let url = download.downloadRequest?.request?.URL?.absoluteString {
            self.activeDownloads[url] = nil
            
            // reload lại cell của đối tượng request vừa được lưu lại.
            if let trackIndex = self.trackIndexForDownloadTask(download.downloadRequest) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: trackIndex, inSection: 0)], withRowAnimation: .None)
                })
            }
        }
    }
    
    //Dir để save file
    func localFilePathForUrl(previewUrl: String) -> NSURL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        if let url = NSURL(string: previewUrl), lastPathComponent = url.lastPathComponent {
            let fullPath = documentsPath.stringByAppendingPathComponent(lastPathComponent)
            return NSURL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    //Check filePath đã tồn tại hay chưa.
    func localFileExistsForTrack(track: Track) -> Bool {
        if let urlString = track.previewUrl, localUrl = localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
            if let path = localUrl.path {
                return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)
            }
        }
        return false
    }
    
    //Dùng MPMoviePlayerVC để chạy track đã download
    func playDownload(track: Track) {
        if let urlString = track.previewUrl, url = localFilePathForUrl(urlString) {
            let moviePlayer:MPMoviePlayerViewController! = MPMoviePlayerViewController(contentURL: url)
            presentMoviePlayerViewControllerAnimated(moviePlayer)
        }
    }
    
    func trackIndexForDownloadTask(downloadTask: Request?) -> Int? {
        
        //Lấy param là 1 đối tượng Request (Download)
        //Check URL của đối tượng có tồn tại hay không.
        //Lấy ra index đối tượng đang được truyền vào.
        if let url = downloadTask?.request?.URL?.absoluteString {
            for (index, track) in searchResults.enumerate() {
                if url == track.previewUrl! {
                    return index
                }
            }
        }
        return nil
    }
}

//MARK: TableViewDataSource
extension SearchViewControllerAlamofire : UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as! TrackCell
        
        cell.delegate = self
        
        let track = searchResults[indexPath.row]
        
        cell.configureCell(track)
        
        var showDownloadControls = false
        
        if let download = activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            
            cell.progressView.progress = download.progress
            cell.progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
            
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, forState: UIControlState.Normal)
        }
        cell.progressView.hidden = !showDownloadControls
        cell.progressLabel.hidden = !showDownloadControls
        
        let downloaded = localFileExistsForTrack(track)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.Gray : UITableViewCellSelectionStyle.None
        cell.downloadButton.hidden = downloaded || showDownloadControls
        
        cell.pauseButton.hidden = !showDownloadControls
        cell.cancelButton.hidden = !showDownloadControls
        
        return cell
    }
}

//MARK: TableViewDelegate
extension SearchViewControllerAlamofire : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 104
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = searchResults[indexPath.row]
        if localFileExistsForTrack(track) {
            playDownload(track)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

//MARK: TrackCell Delegate
extension SearchViewControllerAlamofire : TrackCellDelegate{
    
    func pauseTapped(cell: TrackCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let track = searchResults[indexPath.row]
            pauseDownload(track)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    func resumeTapped(cell: TrackCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let track = searchResults[indexPath.row]
            resumeDownload(track)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    func cancelTapped(cell: TrackCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let track = searchResults[indexPath.row]
            cancelDownload(track)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        }
    }
    
    func downloadTapped(cell: TrackCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let track = searchResults[indexPath.row]
            startDownload(track)
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        }
        
    }
}

//MARK: SearchBar Delegate
extension SearchViewControllerAlamofire : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        dismissKeyboard()
        
        if !searchBar.text!.isEmpty {
            if searchRequest != nil {
                searchRequest?.cancel()
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let expectedCharSet = NSCharacterSet.URLQueryAllowedCharacterSet()
            let searchTerm = searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(expectedCharSet)!
            let url = NSURL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm)")
            
            searchResults.removeAll()
            
            searchRequest = Alamofire.request(.GET, url!).response(completionHandler: { (_, _, data, error) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    
                    if let data = data {
                        
                        let trackInformations = JSON(data: data)
    
                        let resultsArray = trackInformations["results"].array
                        
                        for trackResult in resultsArray!{
                            let track = Track(songInformation: trackResult)
                            self.searchResults.append(track)
                        }
                        
                        self.tableView.reloadData()
                        self.tableView.setContentOffset(CGPointZero, animated: false)
                        
                    }else{
                        print("data is nil")
                    }
                    
                }
            })
            
            searchRequest?.resume()
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
}