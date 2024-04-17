//
//  ReservationCardViewController.swift
//  parking-rental-app
//
//  Created by Никита Лисунов on 4/5/24.
//

import UIKit

// MARK: - ReservationCardViewController
final class ReservationCardViewController: UIViewController {
    // MARK: - Constansts
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Private Properties
    private let interactor: ReservationCardBusinessLogic
    private let router: ReservationCardRoutingLogic
    private let parkingSpotID: String
    private let date: Date
    private let startTime: Date
    private let endTime: Date
    private let spotState: ReservationCardSpotState
    private let onUpdateAction: (() -> Void)
    private var employeeID: String?
    private var carID: String?
    private var reservationID: String?
    private let ovalView = UIView()
    private let titleFirstLineLabel = UILabel()
    private let titleSecondLineLabel = UILabel()
    private let reservationCardView = UIView()
    private let zoneLabel = UILabel()
    private let parkingLotNumberLabel = UILabel()
    private let carLabel = UILabel()
    private let carRegistryNumberLabel = UILabel()
    private let timeSlotLabel = UILabel()
    private let timeLabel = UILabel()
    private let dateLabel = UILabel()
    private let reservationActionButton = UIButton()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingFailureLabel = UILabel()
    private let reloadButton = UIButton()
    private var currentState: ReservationCardState = .loading {
        didSet {
            updateUIForState(currentState)
        }
    }
    
    // MARK: - LifeCycle
    init(
        router: ReservationCardRoutingLogic,
        interactor: ReservationCardBusinessLogic,
        parkingSpotID: String,
        date: Date,
        startTime: Date,
        endTime: Date,
        spotState: ReservationCardSpotState,
        onUpdateAction: @escaping (() -> Void)
    ) {
        self.router = router
        self.interactor = interactor
        self.parkingSpotID = parkingSpotID
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.spotState = spotState
        self.onUpdateAction = onUpdateAction
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
        currentState = .loading
        interactor.loadReservationCardInfo(Model.ReservationCardInfo.Request(parkingSpotID: self.parkingSpotID, spotState: self.spotState, date: self.date, startTime: self.startTime, endTime: self.endTime))
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = Colors.background.uiColor
        configureOvalView()
        configureTitleFirstLineLabel()
        configureTitleSecondLineLabel()
        configureReservationActionButton()
        configureReservationCardView()
        configureZoneLabel()
        configureParkingLotNumberLabel()
        configureCarLabel()
        configureCarRegistryNumberLabel()
        configureTimeLabel()
        configureDateLabel()
        configureTimeSlotLabel()
        configureLoadingIndicator()
        configureLoadingFailureLabel()
        configureReloadButton()
    }
    
    private func configureOvalView() {
        self.view.addSubview(ovalView)
        ovalView.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 5)
        ovalView.pinCenterX(to: self.view.centerXAnchor)
        ovalView.setHeight(5)
        ovalView.setWidth(45)
        ovalView.backgroundColor = Colors.secondaryButton.uiColor
        ovalView.layer.cornerRadius = 2
    }
    
    private func configureTitleFirstLineLabel() {
        self.view.addSubview(titleFirstLineLabel)
        titleFirstLineLabel.pinTop(to: self.view.safeAreaLayoutGuide.topAnchor, 25)
        titleFirstLineLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleFirstLineLabel.numberOfLines = 0
        titleFirstLineLabel.text = "registrationCardLoadingFirstLineTitle".localize()
        titleFirstLineLabel.textAlignment = .left
        titleFirstLineLabel.font = .systemFont(ofSize: 26, weight: .regular)
        titleFirstLineLabel.textColor = Colors.mainText.uiColor
    }
    
    private func configureTitleSecondLineLabel() {
        self.view.addSubview(titleSecondLineLabel)
        titleSecondLineLabel.pinTop(to: self.titleFirstLineLabel.bottomAnchor, 0)
        titleSecondLineLabel.pinLeft(to: self.view.leadingAnchor, 38)
        titleSecondLineLabel.numberOfLines = 0
        titleSecondLineLabel.text = "reservationCardSecondLineTitle".localize()
        titleSecondLineLabel.textAlignment = .left
        titleSecondLineLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleSecondLineLabel.textColor = Colors.mainText.uiColor
    }
    
    private func configureReservationActionButton() {
        self.view.addSubview(reservationActionButton)
        reservationActionButton.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 25)
        reservationActionButton.setHeight(70)
        reservationActionButton.pinHorizontal(to: self.view, 38)
        reservationActionButton.backgroundColor = Colors.secondaryButton.uiColor
        reservationActionButton.layer.cornerRadius = 20
        reservationActionButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
        reservationActionButton.titleLabel?.font = .systemFont(ofSize: 26, weight: .regular)
    }
    
    private func configureReservationCardView() {
        self.view.addSubview(reservationCardView)
        reservationCardView.pinHorizontal(to: self.view, 38)
        reservationCardView.pinTop(to: self.titleSecondLineLabel.bottomAnchor, 25)
        reservationCardView.pinBottom(to: self.reservationActionButton.topAnchor, 25)
        reservationCardView.backgroundColor = .clear
        reservationCardView.layer.borderWidth = 3
        reservationCardView.layer.borderColor = Colors.secondaryButton.uiColor.cgColor
        reservationCardView.layer.cornerRadius = 20
    }
    
    private func configureZoneLabel() {
        self.view.addSubview(zoneLabel)
        zoneLabel.pinTop(to: self.reservationCardView.topAnchor, 20)
        zoneLabel.pinLeft(to: self.reservationCardView.leadingAnchor, 30)
        zoneLabel.text = "zone".localize()
        zoneLabel.textColor = Colors.secondaryText.uiColor
        zoneLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private func configureParkingLotNumberLabel() {
        self.view.addSubview(parkingLotNumberLabel)
        parkingLotNumberLabel.pinTop(to: self.zoneLabel.bottomAnchor, 5)
        parkingLotNumberLabel.pinLeft(to: self.reservationCardView.leadingAnchor, 30)
        parkingLotNumberLabel.textColor = Colors.mainText.uiColor
        parkingLotNumberLabel.font = .systemFont(ofSize: 28, weight: .bold)
    }
    
    private func configureCarLabel() {
        self.view.addSubview(carLabel)
        carLabel.pinTop(to: self.reservationCardView.topAnchor, 20)
        carLabel.pinLeft(to: self.reservationCardView.centerXAnchor, 5)
        carLabel.text = "car".localize()
        carLabel.textAlignment = .left
        carLabel.textColor = Colors.secondaryText.uiColor
        carLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private func configureCarRegistryNumberLabel() {
        self.view.addSubview(carRegistryNumberLabel)
        carRegistryNumberLabel.pinTop(to: self.carLabel.bottomAnchor, 5)
        carRegistryNumberLabel.pinLeft(to: self.reservationCardView.centerXAnchor, 5)
        carRegistryNumberLabel.textAlignment = .left
        carRegistryNumberLabel.textColor = Colors.mainText.uiColor
        carRegistryNumberLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func configureTimeLabel() {
        self.view.addSubview(timeLabel)
        timeLabel.pinBottom(to: self.reservationCardView.bottomAnchor, 20)
        timeLabel.pinLeft(to: self.reservationCardView.leadingAnchor, 30)
        timeLabel.textColor = Colors.mainText.uiColor
        timeLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private func configureDateLabel() {
        self.view.addSubview(dateLabel)
        dateLabel.pinBottom(to: self.reservationCardView.bottomAnchor, 22)
        dateLabel.pinLeft(to: self.timeLabel.trailingAnchor, 10)
        dateLabel.textColor = Colors.mainText.uiColor
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private func configureTimeSlotLabel() {
        self.view.addSubview(timeSlotLabel)
        timeSlotLabel.pinBottom(to: self.timeLabel.topAnchor, 5)
        timeSlotLabel.pinLeft(to: self.reservationCardView.leadingAnchor, 30)
        timeSlotLabel.text = "timeSlot".localize()
        timeSlotLabel.textColor = Colors.secondaryText.uiColor
        timeSlotLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private func configureLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.pinCenter(to: self.reservationCardView)
        loadingIndicator.color = Colors.secondaryText.uiColor
    }
    
    private func configureLoadingFailureLabel() {
        loadingFailureLabel.text = "connectionError".localize()
        loadingFailureLabel.font = .systemFont(ofSize: 18, weight: .bold)
        loadingFailureLabel.textColor = Colors.mainText.uiColor
    }
    
    private func configureReloadButton() {
        reloadButton.setTitle("reload".localize(), for: .normal)
        reloadButton.setTitleColor(Colors.active.uiColor, for: .normal)
        reloadButton.setTitleColor(Colors.secondaryText.uiColor, for: .highlighted)
        reloadButton.backgroundColor = .clear
        reloadButton.addTarget(self, action: #selector(reloadButtonWasPressed), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func reserveLotButtonWasTapped() {
        self.currentState = .loading
        if let employeeID = self.employeeID, let carID = self.carID {
            self.interactor.loadCreateReservation(Model.CreateReservation.Request(employeeID: employeeID, carID: carID, parkingSpotID: self.parkingSpotID, date: self.date, startTime: self.startTime, endTime: self.endTime))
        }
    }
    
    @objc
    private func cancelReservationButtonWasTapped() {
        self.currentState = .loading
        if let reservationID = self.reservationID {
            self.interactor.loadCancelReservation(Model.CancelReservation.Request(reservationID: reservationID))
        }
    }
    
    @objc
    private func reloadButtonWasPressed() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        loadingFailureLabel.removeFromSuperview()
        reloadButton.removeFromSuperview()
        currentState = .loading
        interactor.loadReservationCardInfo(Model.ReservationCardInfo.Request(parkingSpotID: self.parkingSpotID, spotState: self.spotState, date: self.date, startTime: self.startTime, endTime: self.endTime))
    }
    
    private func showLoadingFailure() {
        view.addSubview(loadingFailureLabel)
        loadingFailureLabel.pinCenterX(to: self.reservationCardView.centerXAnchor)
        loadingFailureLabel.pinTop(to: self.reservationCardView.topAnchor, self.reservationCardView.frame.height / 2.0 - 15)
        
        view.addSubview(reloadButton)
        reloadButton.pinTop(to: self.reservationCardView.topAnchor, self.reservationCardView.frame.height / 2.0 + 15)
        reloadButton.pinCenterX(to: self.reservationCardView.centerXAnchor)
    }
    
    private func showReservationsLimit() {
        reservationActionButton.backgroundColor = Colors.secondaryButton.uiColor
        reservationActionButton.setTitleColor(Colors.secondaryText.uiColor.light, for: .normal)
        reservationActionButton.setTitle("reservationsLimit".localize(), for: .normal)
        reservationActionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func showReservationsLimitForTime() {
        reservationActionButton.backgroundColor = Colors.secondaryButton.uiColor
        reservationActionButton.setTitleColor(Colors.secondaryText.uiColor.light, for: .normal)
        reservationActionButton.setTitle("reservationsLimitForTime".localize(), for: .normal)
        reservationActionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
    }
    
    private func showWeekendLimit() {
        reservationActionButton.backgroundColor = Colors.secondaryButton.uiColor
        reservationActionButton.setTitleColor(Colors.secondaryText.uiColor.light, for: .normal)
        reservationActionButton.setTitle("reservationCardWeekendLimit".localize(), for: .normal)
        reservationActionButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
    }
}

// MARK: - DisplayLogic
extension ReservationCardViewController: ReservationCardDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayReservationCardInfo(_ viewModel: Model.ReservationCardInfo.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            self?.employeeID = viewModel.employeeID
            self?.carID = viewModel.carID
            self?.reservationID = viewModel.reservationID
            self?.parkingLotNumberLabel.text = "\(viewModel.parkingLotNumber)"
            self?.carRegistryNumberLabel.text = "\(viewModel.carRegistryNumber)"
            self?.timeLabel.text = "\(viewModel.startTime) - \(viewModel.endTime)"
            self?.dateLabel.text = "\(viewModel.date)"
            if self?.spotState == .freeSpot {
                if viewModel.reservationsLimitForTime {
                    self?.currentState = .reservationsLimitForTime
                } else if viewModel.weekendLimit {
                    self?.currentState = .weekendLimit
                } else if viewModel.reservationsLimit {
                    self?.currentState = .reservationsLimit
                } else {
                    self?.titleFirstLineLabel.text = "reservationCardFreeFirstLineTitle".localize()
                    self?.reservationActionButton.setTitle("reserveLot".localize(), for: .normal)
                    self?.reservationActionButton.backgroundColor = Colors.accent.uiColor
                    self?.reservationActionButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
                    self?.reservationCardView.layer.borderColor = Colors.secondaryButton.uiColor.cgColor
                    self?.reservationActionButton.addTarget(self, action: #selector(self?.reserveLotButtonWasTapped), for: .touchDown)
                }
            } else if self?.spotState == .reservedSpot {
                self?.titleFirstLineLabel.text = "reservationCardReservedFirstLineTitle".localize()
                self?.reservationActionButton.setTitle("cancelReservation".localize(), for: .normal)
                self?.reservationActionButton.backgroundColor = Colors.secondaryButton.uiColor
                self?.reservationActionButton.setTitleColor(Colors.danger.uiColor, for: .normal)
                self?.reservationCardView.layer.borderColor = Colors.accent.uiColor.cgColor
                self?.reservationActionButton.addTarget(self, action: #selector(self?.cancelReservationButtonWasTapped), for: .touchDown)
            }
        }
    }
    
    func displayCreateReservation(_ viewModel: Model.CreateReservation.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            self?.reservationID = viewModel.reservationID
            self?.titleFirstLineLabel.text = "reservationCardReservedFirstLineTitle".localize()
            self?.reservationActionButton.setTitle("cancelReservation".localize(), for: .normal)
            self?.reservationActionButton.backgroundColor = Colors.secondaryButton.uiColor
            self?.reservationActionButton.setTitleColor(Colors.danger.uiColor, for: .normal)
            self?.reservationCardView.layer.borderColor = Colors.accent.uiColor.cgColor
            self?.reservationActionButton.removeTarget(nil, action: nil, for: .allEvents)
            self?.reservationActionButton.addTarget(self, action: #selector(self?.cancelReservationButtonWasTapped), for: .touchDown)
            self?.onUpdateAction()
        }
    }
    
    func displayCancelReservation(_ viewModel: Model.CancelReservation.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .loaded
            self?.reservationID = nil
            self?.titleFirstLineLabel.text = "reservationCardFreeFirstLineTitle".localize()
            self?.reservationActionButton.setTitle("reserveLot".localize(), for: .normal)
            self?.reservationActionButton.backgroundColor = Colors.accent.uiColor
            self?.reservationActionButton.setTitleColor(Colors.mainText.uiColor.light, for: .normal)
            self?.reservationCardView.layer.borderColor = Colors.secondaryButton.uiColor.cgColor
            self?.reservationActionButton.removeTarget(nil, action: nil, for: .allEvents)
            self?.reservationActionButton.addTarget(self, action: #selector(self?.reserveLotButtonWasTapped), for: .touchDown)
            self?.onUpdateAction()
        }
    }
    
    func displayLoadingFailure(_ viewModel: Model.LoadingFailure.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currentState = .error
        }
    }
}

// MARK: - UpdateUIForState
extension ReservationCardViewController {
    func updateUIForState(_ state: ReservationCardState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error:
            loadingIndicator.stopAnimating()
            showLoadingFailure()
        case .reservationsLimit:
            self.showReservationsLimit()
        case .reservationsLimitForTime:
            self.showReservationsLimitForTime()
        case .weekendLimit:
            self.showWeekendLimit()
        }
    }
}
