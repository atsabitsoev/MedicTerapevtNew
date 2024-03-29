//
//  ChatVC.swift
//  MedicApp
//
//  Created by Ацамаз Бицоев on 20/05/2019.
//  Copyright © 2019 Ацамаз Бицоев. All rights reserved.
//

import UIKit
import RxSwift
import RxKeyboard

class ChatVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var viewUnderTF: SimpleGradientView!
    @IBOutlet weak var constrHeaderTop: NSLayoutConstraint!
    @IBOutlet weak var constrLabTitleTop: NSLayoutConstraint!
    @IBOutlet weak var viewSend: ViewUnderTextFields!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var butSend: UIButton! {
        didSet {
            butSend.setImage(butSend.currentImage?.withRenderingMode(.alwaysTemplate),
                             for: .normal)
        }
    }
    @IBOutlet weak var butClose: UIButton! {
        didSet {
            butClose.setImage(butClose.currentImage?.withRenderingMode(.alwaysTemplate),
                             for: .normal)
        }
    }
    @IBOutlet weak var butExercises: UIButton!
    @IBOutlet weak var butDiagnosticResults: UIButton!
    
    
    private var rxFirstCircle = true
    private var topSafeArea: CGFloat = 0
    private var bottomSafeArea: CGFloat = 0
    
    
    private var chatService = ChatService.standard!
    var firstInit = true
    var allMessagesGot = false
    
    
    var titleString: String!
    var patient: PatientItem!
    var messageArr: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        configureView()
        
        chatService.enterChat(dialogId: patient.dialogId)
        
        configureTFMessage()
        tableView.rowHeight = UITableView.automaticDimension
        
        updateVisibleMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeKeyboard()
        if firstInit {
            scrollToBottom(animated: false)
            firstInit = false
        }
    }
    
    
    private func configureView() {
        
        self.labTitle.text = titleString
        butDiagnosticResults.setImage(butDiagnosticResults.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        butExercises.setImage(butExercises.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showHistoryMessages),
                                               name: NSNotification.Name(rawValue: NotificationNames.messagesFetched.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showRecievedMessage), name: NSNotification.Name(NotificationNames.newMessage.rawValue), object: nil)
    }
    
    func scrollToBottom(animated: Bool) {
        
        guard messageArr.count != 0 else { return }
        let indexPath = IndexPath(row: messageArr.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    @objc private func showHistoryMessages() {
        
        updateVisibleMessages()
        activityIndicator.stopAnimating()
    }
    
    @objc private func showRecievedMessage() {
        
        guard let newMessage = chatService.lastMessage else { return }
        visualiseRecievingMessage(text: newMessage.text, time: newMessage.time, contentType: newMessage.contentType, image: newMessage.image)
    }
    
    private func updateVisibleMessages() {
        
        messageArr = MessageHistoryService.standard.messages
        reload(tableView: tableView)
        if messageArr.count % 30 > 0 {
            allMessagesGot = true
        }
    }
    
    func reload(tableView: UITableView) {
        
        tableView.reloadData()
        tableView.layoutIfNeeded()
        let currentRow = (MessageHistoryService.standard.messages.count % 30 == 0) ? 29 : MessageHistoryService.standard.messages.count % 30 - 1
        
        if MessageHistoryService.standard.messages.count != 0 {
            tableView.scrollToRow(at: IndexPath(row: currentRow,
                                                section: 0),
                                  at: .top,
                                  animated: false)
        }
    }
    
    
    //MARK: Клавиатура
    
    private func observeKeyboard() {
        if rxFirstCircle {
            
            RxKeyboard.instance.visibleHeight
                .drive(onNext: { (height) in
                    if self.rxFirstCircle {
                        self.rxFirstCircle = false
                        return
                    }
                    if height == 0 {
                        self.keyboardHide()
                        print("Опустил клавиатуру")
                    } else {
                        self.keyboardUp(height: height)
                        print("Поднял клавиатуру")
                    }
                },
                       onCompleted: {
                        print("Готово")
                })
            
        } 
        
        
    }
    
    private func keyboardUp(height: CGFloat) {
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
        
        print(bottomSafeArea)
        
        self.view.frame.origin.y -= height - bottomSafeArea
        constrHeaderTop.constant += height - bottomSafeArea
        constrLabTitleTop.constant += height - bottomSafeArea
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        scrollToBottom(animated: true)
        
    }
    
    private func keyboardHide() {
        
        self.view.frame.origin.y = 0
        constrHeaderTop.constant = 0
        constrLabTitleTop.constant = 8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Конец работы с клавиатурой
    
    
    private func configureTFMessage() {
        
        tfMessage.delegate = self
        tfMessage.layer.cornerRadius = 8
        
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 0))
        tfMessage.leftViewMode = .always
        tfMessage.leftView = spacerView
    }
    
    
    private func visualiseSendingMessage(text: String, time: Date, contentType: MessageContentType, image: UIImage? = nil) {
        
        messageArr.append(Message(text: text, sender: .user, time: time, contentType: contentType, image: image))
        tfMessage.text = ""
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: messageArr.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        scrollToBottom(animated: true)
        
    }
    
    private func visualiseRecievingMessage(text: String, time: Date, contentType: MessageContentType, image: UIImage? = nil) {
        
        messageArr.append(Message(text: text, sender: .penPal, time: time, contentType: contentType, image: image))
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: messageArr.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        scrollToBottom(animated: true)
        
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let message = Message(text: "",
                                  sender: .user,
                                  time: Date(),
                                  contentType: .photo,
                                  image: pickedImage)
            chatService.sendMessage(message)
            visualiseSendingMessage(text: "", time: Date(), contentType: .photo, image: pickedImage)
            self.dismiss(animated: true, completion: nil)
            
        } else if let pickedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            
            print("Видео")
            let pickedVideoString = "\(pickedVideo)"
            let message = Message(text: pickedVideoString,
                                  sender: .user,
                                  time: Date(),
                                  contentType: .video)
            chatService.sendMessage(message)
            visualiseSendingMessage(text: pickedVideoString,
                                    time: Date(),
                                    contentType: .video)
            self.dismiss(animated: true,
                         completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: IBActions
    @IBAction func butSendTapped(_ sender: UIButton) {
        
        guard let text = tfMessage.text, text != "", text != " " else { return }
        
        chatService.sendMessage(Message(text: text, sender: .user, time: Date(), contentType: .text))
        visualiseSendingMessage(text: text, time: Date(), contentType: .text)
        
    }
    
    @IBAction func butAddImageTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func butDiagnosticTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "DiagnosticResults", bundle: nil)
        let diagnosticVC = storyboard.instantiateViewController(withIdentifier: "DiagnosticResultsVC") as! DiagnosticResultsVC
        diagnosticVC.patientID = self.patient.id
        let navigationController = UINavigationController(rootViewController: diagnosticVC)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func butExercises(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Excercises", bundle: nil)
        let exercisesVC = storyboard.instantiateViewController(withIdentifier: "ExcercisesVC") as! ExcercisesVC
        exercisesVC.patientID = self.patient.id
        self.present(exercisesVC, animated: true, completion: nil)
    }
    
    
    @IBAction func butCloseTapped(_ sender: UIButton) {
        
        chatService.exitFromChat()
        MessageHistoryService.standard.messages = []
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}
