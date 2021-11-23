import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet var albumView: UIView!
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    func configureAlbumCell(album: Album) {
        
        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { [weak self] result in
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
        
        albumLabel.text = album.collectionName
        nameLabel.text = album.artistName
    }
}
