//
//  ViewController.swift
//  MeddyTeddy_chatBot
//
//  Created by ketan jogal on 24/10/21.
//

import UIKit

class ChatScreen: UIViewController {

    @IBOutlet weak var tblChatView: UITableView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessageView: UITextView!
    @IBOutlet weak var vewTxtVewContainer: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    

    @IBOutlet weak var messageBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var lblNoResult: UILabel!
   // @IBOutlet weak var constantTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblChatTitle: UILabel!
    
    
    //MARK: Variables
    
    private var viewModel: ChatScreenViewModel = ChatScreenViewModel()
    private var scrollToBottomWrokItem:DispatchWorkItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tblChatView.reloadData()
        intilizeView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //txtMessageView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Methods..
    
    private func chatWithBot(){
        let message = ChatMessage(message: txtMessageView.text.trimmingCharacters(in: .whitespacesAndNewlines))
        self.showLoader()
        viewModel.chatWithBot(chatMessage: message) { [weak self] (message, err) in
            self?.hideLoader()
            DispatchQueue.main.async {
                if let erroMessage = err {
                    self?.showAlert(message: erroMessage)
                } else {
                    //self?.intilizeView()
                    self?.tblChatView.reloadData()
                }
            }
        }
    }

    private func intilizeView() {
        self.txtMessageView.text =  "Type Message"
        self.addGestureToHideKeyboard()
        self.addKeyboardObserver()
    }
    
    private func setUpTextView(){
        txtMessageView.translatesAutoresizingMaskIntoConstraints = false
        txtMessageView.font = UIFont.preferredFont(forTextStyle: .headline)
        txtMessageView.delegate = self
        txtMessageView.isScrollEnabled = false
        textViewDidChange(txtMessageView)
    }
    
    private func showData(){
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func retriveFireBaseMessages(){

    }
    
    private func setUpTableView(){
        self.tblChatView.rowHeight = UITableView.automaticDimension
        self.tblChatView.estimatedRowHeight = 120
        self.tblChatView.reloadData()
        let headerNib = UINib.init(nibName: "DateSectionView", bundle: Bundle.main)
        tblChatView.register(headerNib, forHeaderFooterViewReuseIdentifier: "DateSectionView")
    }
    
    private func scrollToLast() {
        
        
    }
    
    @objc func handleKeyBoardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
            messageBottomSpace.constant = isKeyBoardShowing ? keyboardSize!.height + 40 : 40
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {[weak self] () in
                DispatchQueue.main.async {
                    self?.view.layoutIfNeeded()
                }
            }) { [weak self] (completed) in
                DispatchQueue.main.async {
                    if let weakS = self {
                        if weakS.navigationController?.visibleViewController == weakS {
                            self?.scrollToLast()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSendPressed(_ sender: Any) {
        chatWithBot()
    }

}
// MARK: - UITableViewDataSource/UITableViewDelegate

extension ChatScreen: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = viewModel.messageArray[indexPath.row]
        if msg.chatBotID != nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedMessageCell.reusableIdentifier, for: indexPath) as! ReceivedMessageCell
            cell.setupCell(message: msg)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SendMessageCell.reusableIdentifier, for: indexPath) as! SendMessageCell
            cell.setupCell(message: msg)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateSectionView") as! DateSectionView
       // headerView.lblDateHeader.text = viewModel.filteredSection[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

// MARK: GroupChatViewModelDelegate

extension ChatScreen{
    func scrollToBottom()  {
        scrollToBottomWrokItem?.cancel()
        scrollToBottomWrokItem = DispatchWorkItem.init(block: {[weak self] () in
            self?.tblChatView.reloadData()
            self?.scrollToLast()
        })
        DispatchQueue.main.async(execute: scrollToBottomWrokItem!)
    }
    
    func reloadChat(){
        setUpTableView()
        scrollToBottom()
        txtMessageView.isUserInteractionEnabled = true
    }
}

//MARK:- UITextViewDelegates

extension ChatScreen: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Message" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    @objc(textViewDidChange:) func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" || textView.text == "Type Message" || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            btnSend.isEnabled = false
        }else{
            btnSend.isEnabled = true
        }
    
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        //textView.scrollT
        
        if textView.frame.size.height >= 120.0{
            textView.frame.size.height = containerHeight.constant - 30
            textView.isScrollEnabled = true
            let bottomOff = CGRect(x: 0, y: textView.contentSize.height - textView.bounds.size.height + textView.contentInset.bottom, width: textView.frame.size.width, height: textView.frame.size.height)
            textView.scrollRectToVisible(bottomOff, animated: false)
        }
        else
            {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false
        }
        
        print("height1>>>",containerHeight.constant)
        print("height2>>>",textView.frame.size.height)
        print("height3>>",textView.contentSize.height)
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type Message"
            textView.textColor = UIColor.lightGray
        }
    }
}


