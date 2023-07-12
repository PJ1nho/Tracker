//
//  ScheduleTableView.swift
//  Tracker
//
//  Created by Тихтей  Павел on 22.04.2023.
//

import UIKit

protocol ScheduleTableViewDelegate: AnyObject {
    func didSelectSchedule(schedule: [Schedule])
}

final class ScheduleTableView: UIView {
    
    private var tableView = UITableView()
    private let days = Schedule.allCases
    var selectedSchedule: Set<Schedule> = []
    
    weak var delegate: ScheduleTableViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    
    func setupUI() {
        configureTableView()
        configureConstraints()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func switchStatus() {
        for (index, weekDay) in Schedule.allCases.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            guard let switchView = cell?.accessoryView as? UISwitch else {return}

            if switchView.isOn {
                selectedSchedule.insert(weekDay)
            } else {
                selectedSchedule.remove(weekDay)
            }
        }
    }
    
    @objc func switcherValueChanged(switcher: UISwitch) {
        switchStatus()
        delegate?.didSelectSchedule(schedule: Array(selectedSchedule))
    }
}

    // MARK: - UITableViewDataSource

extension ScheduleTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = days[indexPath.row].rawValue
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.isOn = cell.isSelected
        switchView.onTintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        switchView.addTarget(self, action: #selector(switcherValueChanged), for: UIControl.Event.valueChanged)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        return cell
    }
    

}

    // MARK: - UITableViewDelegate

extension ScheduleTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
