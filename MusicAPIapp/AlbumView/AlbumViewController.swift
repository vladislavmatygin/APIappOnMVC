import UIKit

class AlbumViewController: UIViewController {
    var album: Album?
    var songs = [Song]()
    
    @IBOutlet var forScrollView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setModel()
        setup()
        fetchSong(album: album)
    }
    
    private func setModel() {
        
        guard let album = album else { return }
        
        titleLabel.text = "Альбом: \(album.collectionName)"
        nameLabel.text = "Испольнитель: \(album.artistName)"
        countLabel.text = "Колличество треков: \(album.trackCount)"
        releaseDateLabel.text = "Опубликованно: \(setDataFormat(data: album.releaseDate))"
        
        guard let url = album.artworkUrl100 else { return }
        setImage(urlString: url)
    }
    
    private func setup() {
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "songCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: Work with release date
    private func setDataFormat(data: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = dateFormatter.date(from: data) else { return "" }
        
        let formateDate = DateFormatter()
        formateDate.dateFormat = "dd-MM-yyyy"
        let date = formateDate.string(from: backendDate)
        return date
    }
    
    //MARK: Work with album image
    private func setImage(urlString: String?) {
        
        if let url = urlString {
            NetworkRequest.shared.requestData(urlString: url) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumImageView.image = image
                case .failure(let error):
                    self?.albumImageView.image = nil
                    print("NO AlbumImage" + error.localizedDescription)
                }
            }
        } else {
            albumImageView.image = nil
        }
    }
    
    private func fetchSong(album: Album?) {
        
        guard let album = album else { return }
        
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetworkDataFetch.shared.fetchSong(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else { return }
                
                self?.songs = songModel.results
                self?.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
//        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as? SongTableViewCell {
            let song = songs[indexPath.row].trackName
            cell.cellLabel.text = song
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
