import SwiftUI

struct MonthView: View {
    
    var monthBudget : MonthBudget
    
    var body: some View {
        Text(monthBudget.monthDesignation)
    }
}

/*
#Preview {
    MonthView()
}
*/
