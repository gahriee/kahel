import Foundation

struct RpgEffects {
    let hpDamage: Int
    let xpGained: Int
    let goldGained: Int
}

enum RpgEngine {
    
    /// Calculate max HP for a given level.
    static func maxHpForLevel(_ level: Int) -> Int {
        return 100 + (level - 1) * 20
    }
    
    /// Calculate XP required to reach the NEXT level.
    static func xpForNextLevel(_ currentLevel: Int) -> Int {
        return currentLevel * 1000
    }
    
    /// Processes an expense against the user's budget and class.
    static func processExpense(
        amount: Double,
        category: String,
        categoryBudgetRemaining: Double,
        overallBudgetRemaining: Double,
        userClass: String
    ) -> RpgEffects {
        
        var xp = 10
        var gold = 5
        var damage = 0
        
        // 1. Savings grant big bonuses
        if category == "Savings" {
            xp += Int(amount * 0.1) // 10% of saved amount as XP
            gold += Int(amount * 0.05)
            return RpgEffects(hpDamage: damage, xpGained: xp, goldGained: gold)
        }
        
        // 2. Class passive bonuses
        switch userClass {
        case "Saver":
            // Savers get extra XP for staying under budget
            if amount <= categoryBudgetRemaining {
                xp += 15
            }
        case "Minimalist":
            // Minimalists get flat extra gold when they spend on needs (Food/Transport/Utilities)
            let needs = ["Food", "Transport", "Utilities"]
            if needs.contains(category) {
                gold += 10
            }
        case "Hustler":
            // Hustlers get more overall XP and Gold from logging anything
            xp += 10
            gold += 10
        default:
            break
        }
        
        // 3. Penalty calculation (Damage)
        // If they exceed category budget
        if amount > categoryBudgetRemaining {
            let overspend = amount - max(0, categoryBudgetRemaining)
            damage += Int(overspend * 0.05) // 5% of overspend as damage
        }
        
        // If they exceed overall budget (severe penalty)
        if amount > overallBudgetRemaining {
            let overspend = amount - max(0, overallBudgetRemaining)
            damage += Int(overspend * 0.1) // 10% of overall overspend as damage
            
            // Hustlers take 20% less penalty damage
            if userClass == "Hustler" {
                damage = Int(Double(damage) * 0.8)
            }
        }
        
        return RpgEffects(hpDamage: damage, xpGained: xp, goldGained: gold)
    }
}
