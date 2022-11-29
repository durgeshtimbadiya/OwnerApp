//
//  App_StoryBoard.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

class App_StoryBoard: NSObject {
    override private init() {}

    static let shared: App_StoryBoard = .init()

    public func StoryBoardLogin() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardMain, bundle: nil)
    }

    public func StoryBoardQuickConsultation() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardQuickConsultation, bundle: nil)
    }

    public func StoryBoardPrescriptionRequest() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardPrescriptionRequest, bundle: nil)
    }

    public func StoryBoardEcommerce() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardEcommerce, bundle: nil)
    }

    public func StoryBoardScheduledAppointment() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardScheduledAppointment, bundle: nil)
    }

    public func StoryBoardHome() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardHome, bundle: nil)
    }

    public func StoryBoardMain() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardMain, bundle: nil)
    }

    public func StoryBoardCreateUser() -> UIStoryboard {
        return UIStoryboard(name: StoryBoard.StoryBoardCreateVideo, bundle: nil)
    }
}
