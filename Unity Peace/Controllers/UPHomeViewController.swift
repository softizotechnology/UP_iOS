//
//  UPHomeViewController.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit
import PagingMenuController

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    private let viewController1 = UPWatchViewController(nibName: "UPWatchViewController", bundle: nil)
    private let viewController2 = UPDiaryViewController(nibName: "UPDiaryViewController", bundle: nil)
    private let viewController3 = UPCalendarViewController(nibName: "UPCalendarViewController", bundle: nil)
    private let viewController4 = UPMenuViewController(nibName: "UPMenuViewController", bundle: nil)
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [viewController1, viewController2, viewController3,viewController4]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .scrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3(), MenuItem4()]
        }
        
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: .white, horizontalPadding: 0, verticalPadding: 0)
        }
        
        var backgroundColor: UIColor {
            return Constants.NavigationBarTintColor
        }
        
        var selectedBackgroundColor: UIColor {
            return Constants.NavigationBarTintColor
        }
    }
    
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Home", color : .white, selectedColor : .white, font: UIFont.systemFont(ofSize: 16), selectedFont : UIFont.boldSystemFont(ofSize: 16)))
        }
    }
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Diary", color : .white, selectedColor : .white, font: UIFont.systemFont(ofSize: 16), selectedFont : UIFont.boldSystemFont(ofSize: 16)))
        }
    }
    
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Calendar", color : .white, selectedColor : .white, font: UIFont.systemFont(ofSize: 16), selectedFont : UIFont.boldSystemFont(ofSize: 16)))
        }
    }
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "Menu", color : .white, selectedColor : .white, font: UIFont.systemFont(ofSize: 16), selectedFont : UIFont.boldSystemFont(ofSize: 16)))
        }
    }
}


class UPHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Unity Peace"

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpPageMenu()
    }
    
    fileprivate func setUpPageMenu () {
        
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case .didScrollStart:
                print("Scroll start")
            case .didScrollEnd:
                print("Scroll end")
            }
        }
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParentViewController: self)
        
        
    }

}
