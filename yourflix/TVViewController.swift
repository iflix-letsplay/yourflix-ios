import UIKit

class TVViewController: UICollectionViewController {
    let dataSource = TVDataSource()
    let dataLoader = TVDataLoader(resource: "tv")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.shows = dataLoader.load()
        collectionView?.dataSource = dataSource
    }
}

extension TVViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let tvCell = cell as? TVCell else { return }

        let asset = dataSource.shows[indexPath.row]

        guard let url = URL(string: "https:\(asset.imageUrl)") else { return }

        let request = URLRequest(url: url)

        tvCell.imageDownloadTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            DispatchQueue.main.async {
                tvCell.imageView.image = UIImage(data: data)
            }
        }

        tvCell.imageDownloadTask?.resume()
    }
}
