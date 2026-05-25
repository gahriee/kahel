import UIKit

enum AppTheme {
    static func configure() {
        // Navigation Bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        // Background relies on UITraitCollection for light/dark mode, 
        // we can set standard colors later per UIViewController or by setting a global proxy
        
        // To accurately reflect the trait collection, we'll configure these dynamically in view controllers,
        // but we can set up standard text attributes here.
        navBarAppearance.titleTextAttributes = [
            .font: AppFonts.pixel(size: 10),
            .foregroundColor: AppColors.accent
        ]
        
        navBarAppearance.shadowColor = .clear // Remove bottom border line
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = AppColors.gold
    }
}
