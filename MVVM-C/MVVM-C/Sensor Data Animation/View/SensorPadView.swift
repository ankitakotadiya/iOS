//
//  SensorPadView.swift
//  CarviOSTask
//
//  Created by Ankita Kotadiya on 30/07/23.
//

import UIKit

class SensorPadView: UIView {
    
    private var isRedColor = true
    private var sensorPads: [UIView] = []

    init(data: [String]) {
        super.init(frame: .zero)
        setupSensorPads(data: data)
        setupToggleColorButton()
        setupAnimateButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupSensorPads(data: [String]) {
        
        for rowData in data {
            if !rowData.isEmpty {
                let rowComponents = rowData.components(separatedBy: ",")
                
                let x = CGFloat(Double(rowComponents[0]) ?? 0.0)
                let y = CGFloat(Double(rowComponents[1]) ?? 0.0)
                let radius = CGFloat(Double(rowComponents[2]) ?? 12.0)
                let screenWidth = UIScreen.main.bounds.size.width/2.5
                let scrrenHeight = UIScreen.main.bounds.size.height/3
                
                let pad = UIView()
                pad.backgroundColor = UIColor.systemRed
                pad.layer.cornerRadius = radius/2
                addSubview(pad)
                
                // Add constraints for the sensor pad
                pad.translatesAutoresizingMaskIntoConstraints = false
                pad.centerXAnchor.constraint(equalTo: leadingAnchor, constant: screenWidth+x).isActive = true
                pad.centerYAnchor.constraint(equalTo: topAnchor, constant: scrrenHeight+y).isActive = true
                pad.widthAnchor.constraint(equalToConstant: radius ).isActive = true
                pad.heightAnchor.constraint(equalToConstant: radius ).isActive = true
                
                sensorPads.append(pad)
            }
        }
    }

    private func setupToggleColorButton() {
        let toggleButton = UIButton()
        toggleButton.setTitle("Toggle Color", for: .normal)
        toggleButton.setTitleColor(.black, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleColorButtonTapped), for: .touchUpInside)
        addSubview(toggleButton)

        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toggleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }

    private func setupAnimateButton() {
        let animateButton = UIButton()
        animateButton.setTitle("Animate", for: .normal)
        animateButton.setTitleColor(.black, for: .normal)
        animateButton.addTarget(self, action: #selector(animateButtonTapped), for: .touchUpInside)
        addSubview(animateButton)

        animateButton.translatesAutoresizingMaskIntoConstraints = false
        animateButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        animateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }

    @objc private func toggleColorButtonTapped() {
        for pad in sensorPads {
            pad.backgroundColor = isRedColor ? .systemBlue : .systemRed
        }
        isRedColor.toggle()
    }

    @objc private func animateButtonTapped() {
        UIView.animate(withDuration: 2.0) {
            for (index, pad) in self.sensorPads.enumerated() {
                let nextIndex = (index + 1) % self.sensorPads.count
                let nextPad = self.sensorPads[nextIndex]
                pad.center = nextPad.center
            }
        }
    }
}
