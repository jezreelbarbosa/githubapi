//
//  TargetError.swift
//  Networking
//
//  Created by Jezreel Barbosa on 13/08/24.
//

import Foundation

public enum TargetError: Error {
    case urlError
    case requestError(Data?, URLResponse?, Error)
    case unknowError(Data?, URLResponse?, Error?)
    case clientError(Data, HTTPURLResponse)
    case serverError(Data, HTTPURLResponse)
    case decodingError(Data, HTTPURLResponse, Error)
}
