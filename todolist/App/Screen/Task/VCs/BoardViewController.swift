
//
//  BoardViewController.swift
//  todolist
//
//  Created by Mac on 19/09/2019.
//  Copyright © 2019 Mac. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import MobileCoreServices

class BoardViewController: UIViewController {
    var tasks = [Task]()
    var boardID = ""
    var boardName = ""  // for board title
    var boardIndex: Int?    //for updateboardAPI
    static var taskID = ""
    var status = [Status(name: "Todo", items: [])]
    var deleteTask = ""
    //var tableView = UITableView()
    var horizonalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    var checkCollectionview = UICollectionView(frame: .infinite, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout = UICollectionViewFlowLayout()
    let layout2 = UICollectionViewFlowLayout()
    var collectionView = UICollectionView(frame: .infinite, collectionViewLayout: UICollectionViewFlowLayout.init())
    let footerID = "footerID"
    
    var viewModel: DashBoardVM?
    
    private var checkTextField: String? //check board Title if are the same
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.isNavigationBarHidden = false
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
    
        checkCollectionview.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        getCurrentDateTime()
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        //        if let decoded  = UserDefaults.standard.data(forKey: "Tasks")
        //        {
        //            let decodedTasks = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Task]
        //            self.tasks = decodedTasks
        //        }
        // updateCollectionViewItem(with: view.bounds.size)
        checkCollectionview.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID)
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        layout.scrollDirection = .horizontal
        layout2.scrollDirection = .horizontal
        self.view.addSubview(checkCollectionview)
        checkCollectionview.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview()
            make.height.equalTo(80)
            make.width.equalToSuperview()
        }
        checkCollectionview.delegate = self
        checkCollectionview.dataSource = self
        checkCollectionview.register(StatusCollectionViewCell.self, forCellWithReuseIdentifier: "Status")
        //checkCollectionview.layer.borderColor = UIColor.black.cgColor
        checkCollectionview.backgroundColor = UIColor.groupTableViewBackground
        checkCollectionview.collectionViewLayout = layout2
        
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(checkCollectionview.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(374)
            make.bottom.equalToSuperview().offset(-100)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        
        setupBarTitle()
    }
    
    final private func setupBarTitle(){
        let boardTextField = UITextField()
        boardTextField.snp.makeConstraints{ make in
            make.width.equalTo(100)
        }
        boardTextField.text = boardName
        boardTextField.delegate = self
        self.navigationItem.titleView = boardTextField
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readTaskApi(boardID: boardID) { (error, tasks) in
            if let error = error {
                self.getonTaskerror(error: error)
                print(error.localizedDescription)
                return
            }
            if let tasks = tasks {
                //UserDefaults.standard.removeObject(forKey: "Tasks")
                self.onreciveTask(tasks: tasks)
                self.createStatus()
                self.collectionView.reloadData()
                self.checkCollectionview.reloadData()
                return
            }
        }
        
        
    }
    func getCurrentDateTime() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.dateFormat = "EE, dd MMM"
        let str = formatter.string(from: Date())
    }
    
    
    func createStatus ()
    {
        for j in tasks
        {
            var check = true
            for i in status          {
                if j.status == i.name
                {
                    check = false
                    i.items.append(j)
                }
                
            }
            if check == true{
                status.append(Status(name: j.status!, items: [j]))
            }
        }
    }
    func checkStatus() -> Bool
    {
        var check = true
        for j in tasks
        {
            
            for i in status          {
                if j.status == i.name
                {
                    check = false
                    return check
                }
            }
        }
        return check
    }
    func getonTaskerror (error: Error)
    {
        
    }
    func onreciveTask (tasks: [Task])
    {
        self.tasks = tasks
        //        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.tasks)
        //        UserDefaults.standard.set(encodedData, forKey: "Tasks")
        //        UserDefaults.standard.synchronize()
    }
    func receiveStatus (status: [Status])
    {
        self.status = status
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCollectionViewItem(with: size)
    }
    private func updateCollectionViewItem(with size: CGSize) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: 225, height: size.height * 0.8)
    }
    
    //    func setupAddTaskBtn() {
    //        let button = UIButton(type: . system)
    //        button.setTitle("Add Task", for: .normal)
    //        button.setTitleColor(.red, for: .normal)
    //        button.frame.size = CGSize(width: 30,height: 30)
    //        button.addTarget(BoardCollectionViewCell.sharedInstance, action: #selector(BoardCollectionViewCell.addTapped(_:)), for: .touchUpInside)
    //        let removeBarButton = UIBarButtonItem(customView: button)
    //        toolbarItems?.append(removeBarButton)
    //    }
    func setupRemoveButtonItem(){
        let button = UIButton(type: . system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.frame.size = CGSize(width: 30,height: 30)
        button.addInteraction(UIDropInteraction(delegate: self))
        let removeBarButton = UIBarButtonItem(customView: button)
        toolbarItems?.append(removeBarButton)
        
    }
    func setupBackbuttonItem() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backtoBoard(_:)))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backtoBoard(_ sender: Any){
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
        //            self.present(vc, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func setupAddButtonItem() {
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListTapped(_:)))
        addButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let homeViewcontroller = storyboard?.instantiateViewController(withIdentifier: "Home") as! UINavigationController
            self.present(homeViewcontroller, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    @objc func addListTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Status", message: nil, preferredStyle: .alert)
        alertController.addTextField{(textField) in
            textField.placeholder = "Status"
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let text = alertController.textFields![0].text, !text.isEmpty else {
                return
            }
            
            self.status.append(Status(name: text, items: []))
            let addedIndexPath = IndexPath(item: self.status.count - 1, section: 0)
            
            self.checkCollectionview.insertItems(at: [addedIndexPath])
            self.checkCollectionview.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            self.checkCollectionview.selectItem(at: addedIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            self.collectionView.insertItems(at: [addedIndexPath])
            self.collectionView.scrollToItem(at: addedIndexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
        
    }
    
    
    
    func setupHorizonalBar () {
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalBarView)
        
        horizonalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: checkCollectionview.leftAnchor)
        horizonalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: checkCollectionview.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: checkCollectionview.widthAnchor, multiplier:  1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
}
extension BoardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == checkCollectionview{
            let cell = checkCollectionview.dequeueReusableCell(withReuseIdentifier: "Status", for: indexPath) as! StatusCollectionViewCell
            cell.number.text = status[indexPath.item].name
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.orange.cgColor
            cell.backgroundColor = UIColor.white
            return cell
            
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BoardCollectionViewCell
            cell.layer.cornerRadius = 0
            cell.layer.borderWidth = 0
            cell.setup(with: status[indexPath.item], boardID: self.boardID)
            cell.parentVC = self
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func scrolltoMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: [] , animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*print(indexPath.item)
         let x = CGFloat(indexPath.item) * collectionView.frame.width / 4
         horizonalBarLeftAnchorConstraint?.constant = x
         UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {self.checkcollectionview.layoutIfNeeded()}, completion: nil)*/
        scrolltoMenuIndex(menuIndex: indexPath.item)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset.x)
        horizonalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / scrollView.frame.width
        let indexPath = IndexPath(item: Int(index + 0.1), section: 0)
        checkCollectionview.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == checkCollectionview {
            return CGSize(width: 93, height: 46)
        }
        else {
            return CGSize(width: 374, height: 600)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 93 + 17*2, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = checkCollectionview.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerID, for: indexPath)
        let addButton = UIButton()
        addButton.addTarget(self, action: #selector(addListTapped(_:)), for: .touchUpInside)
        addButton.setTitle("Add Status", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        footer.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        footer.layer.cornerRadius = 15
        footer.layer.borderWidth = 17
        footer.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        footer.backgroundColor = .white
        return footer
    }
    
}

extension BoardViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            session.loadObjects(ofClass: NSString.self) { (items) in
                guard let _ = items.first as? String else {
                    return
                }
                
                if let (dataSource, sourceIndexPath, tableView) = session.localDragSession?.localContext as? (Status, IndexPath, UITableView) {
                    
                    tableView.beginUpdates()
                    for i in self.tasks{
                        print("Task:\(i.taskName) \(i.taskID) \(i.status)")
                    }
                    let item = dataSource.items[sourceIndexPath.row]
                    dataSource.items.remove(at: sourceIndexPath.row)
                    
                    if let item = self.tasks.first (where: { (task) -> Bool in
                        return task.taskID == item.taskID
                    }){}
                    //self.tasks.remove(at: sourceIndexPath.item)
                    tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                    tableView.endUpdates()
                    deleteTaskAPI(task: item, boardID: self.boardID)
                    
                }
            }
        }
    }
}

extension BoardViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("editing title")
        if textField.text != checkTextField{
            let alertController = UIAlertController(title: "Change board name", message: nil, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                //updateBoardAPI(board: DashboardViewController.boards[self.boardIndex!], newName: textField.text!)
                updateBoardAPI(board: self.viewModel!.returnBoardAtIndex(index: self.boardIndex!), newName: textField.text!)
                self.checkTextField = textField.text
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(alertController,animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.checkTextField = textField.text
    }
}

