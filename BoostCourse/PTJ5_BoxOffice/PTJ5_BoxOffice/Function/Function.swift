//
//  SortAlert.swift
//  PTJ5_BoxOffice
//
//  Created by mong on 11/03/2019.
//  Copyright © 2019 mong. All rights reserved.
//

import Foundation
import UIKit

func changeTitle(requestType: Int) -> String {
    switch requestType {
    case 0:
        return "예매율순"
    case 1:
        return "큐레이션"
    case 2:
        return "개봉일순"
    default:
        return "error"
    }
}

func setGradeImage(grade: Int) -> UIImage {
    switch grade {
    case 0:
        return UIImage(named: "ic_allages")!
    case 12:
        return UIImage(named: "ic_12")!
    case 15:
        return UIImage(named: "ic_15")!
    case 19:
        return UIImage(named: "ic_19")!
    default:
        return UIImage(named: "ic_user_roading")!
    }
}
