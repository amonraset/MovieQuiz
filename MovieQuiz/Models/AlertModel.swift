//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by sm on 20.09.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
