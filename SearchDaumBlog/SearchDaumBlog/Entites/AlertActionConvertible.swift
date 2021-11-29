//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by Sh Hong on 2021/11/29.
//

import Foundation
import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
