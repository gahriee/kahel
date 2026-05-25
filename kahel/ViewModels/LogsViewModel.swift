import Foundation
import FirebaseFirestore

@MainActor
class LogsViewModel: ObservableObject {
    @Published var items: [Expense] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var error: Error?
    @Published var hasMore = true
    
    private var cursor: DocumentSnapshot?
    
    func loadFirstPage(uid: String) async {
        isLoading = true
        error = nil
        cursor = nil
        hasMore = true
        
        defer { isLoading = false }
        
        do {
            let page = try await FirestoreService.shared.fetchExpensePage(uid: uid, after: nil, limit: 20)
            items = page.items
            cursor = page.cursor
            hasMore = page.hasMore
        } catch {
            self.error = error
        }
    }
    
    func loadMore(uid: String) async {
        guard hasMore, !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        do {
            let page = try await FirestoreService.shared.fetchExpensePage(uid: uid, after: cursor, limit: 20)
            items.append(contentsOf: page.items)
            cursor = page.cursor
            hasMore = page.hasMore
        } catch {
            // handle error
        }
    }
}
