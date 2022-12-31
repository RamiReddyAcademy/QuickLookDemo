//
//  ViewController.swift
//  RamiQuickLookDemo
//
//  Created by RamiReddy on 11/12/22.
//

import UIKit
import QuickLook

class ViewController: UIViewController {

    @IBOutlet weak var filesCollectionView: UICollectionView!
    weak var previewItemCell: PreviewItemCell?
    var files = [File]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRegisterView()
        docuemntSavedIntoLocal()
        files = loadFiles()
        print("files count",files.count)
    }

    
    func setUpRegisterView() {
        self.filesCollectionView.register(PreviewItemCell.xibFile, forCellWithReuseIdentifier: PreviewItemCell.cellIdentifier)
    }
    
    func loadFiles() -> [File] {
        let fileManger = FileManager.default
        guard let documentURL = fileManger.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        var url = [URL]()
        do {
            url = try fileManger.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
        
        } catch {
            fatalError("not load")
        }
        return url.map { File(url: $0) }
    }
    
    func docuemntSavedIntoLocal(){
        guard UserDefaults.standard.bool(forKey: "copy") else {
            let files = [Bundle.main.url(forResource: "videoFile", withExtension: "mp4"),Bundle.main.url(forResource: "fileSample", withExtension: "doc"),Bundle.main.url(forResource: "istockphoto-1263562386-170667a", withExtension: "jpeg"),Bundle.main.url(forResource: "sample2", withExtension: "html"),Bundle.main.url(forResource: "Leharaayi", withExtension: "mp3")]
            files.forEach {
                guard let url = $0 else {return}
                do {
                    let newUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent( url.lastPathComponent)
                    try FileManager.default.copyItem(at: url, to: newUrl)

                } catch {
                    print(error.localizedDescription)
                }
            }
            UserDefaults.standard.set(true, forKey: "copy")
            return
        }
    }
    
    

}

extension ViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let quicklookViewController = QLPreviewController()
        quicklookViewController.dataSource = self
        quicklookViewController.delegate = self
        quicklookViewController.currentPreviewItemIndex = indexPath.row
        present(quicklookViewController, animated: true)
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.filesCollectionView.frame.size.width/3 - 10, height: 150)
    }
}

extension ViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filesCollectionView.dequeueReusableCell(withReuseIdentifier: PreviewItemCell.cellIdentifier, for: indexPath) as? PreviewItemCell
        else {
            return UICollectionViewCell()
        }
        cell.setUpPreviewItem(file: files[indexPath.row])
        
        return cell
    }
    
    
}

extension ViewController:QLPreviewControllerDataSource{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
         files[index]
    }
}


extension ViewController:QLPreviewControllerDelegate{
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        previewItemCell?.previewItemImageView
    }
    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
        .updateContents
    }
    func previewController(_ controller: QLPreviewController, didUpdateContentsOf previewItem: QLPreviewItem) {
        guard let file = previewItem as? File else { return }
        DispatchQueue.main.async {
            self.previewItemCell?.setUpPreviewItem(file: file)
        }
    }
    
    
}
