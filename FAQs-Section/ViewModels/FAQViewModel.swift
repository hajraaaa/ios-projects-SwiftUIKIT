import Foundation

class FAQViewModel {
    private var faqs: [FAQ] = [
        FAQ(question: "What is your return policy?", answer: "You can return items within 30 days.", isExpanded: false),
                FAQ(question: "How do I track my order?", answer: "You can track your order using the tracking number provided.", isExpanded: false),
                FAQ(question: "What is the difference between `UIView` and `UIViewController`?", answer: "`UIView` is a building block for UI elements, while `UIViewController` manages the view hierarchy and interactions.", isExpanded: false),
                FAQ(question: "How do you handle asynchronous tasks in Swift?", answer: "Use `DispatchQueue`, `async`/`await`, or `Combine` for handling asynchronous tasks.", isExpanded: false),
                FAQ(question: "What are Auto Layout constraints and why are they important?", answer: "Auto Layout constraints define view positioning and sizing rules for responsive layouts.", isExpanded: false),
                FAQ(question: "How do you manage state in a SwiftUI application?", answer: "Use property wrappers like `@State`, `@Binding`, `@ObservedObject`, and `@EnvironmentObject`.", isExpanded: false),
                FAQ(question: "What is the purpose of the `AppDelegate` in an iOS application?", answer: "The `AppDelegate` handles application lifecycle events and configuration.", isExpanded: false),
                FAQ(question: "How do you implement a table view with dynamic height cells?", answer: "Use Auto Layout constraints, set `rowHeight` to `automaticDimension`, and provide an estimated height.", isExpanded: false),
                FAQ(question: "What is Core Data and when should you use it?", answer: "Core Data manages the model layer with object-oriented persistence and relationships.", isExpanded: false),
                FAQ(question: "How do you handle deep linking in an iOS application?", answer: "Use URL schemes, Universal Links, or `UIApplicationDelegate` methods to manage deep linking.", isExpanded: false),
                FAQ(question: "What is the difference between `@State` and `@Binding` in SwiftUI?", answer: "`@State` is for a view's internal state, while `@Binding` creates a two-way connection to a value managed by a parent view.", isExpanded: false),
                FAQ(question: "How can you implement user authentication in an iOS app?", answer: "Use OAuth, Firebase Authentication, or custom authentication flows with best practices for security.", isExpanded: false),
    ]
    
    var numberOfFAQs: Int {
        return faqs.count
    }
    
    func faq(at index: Int) -> FAQ {
        return faqs[index]
    }
    
    func toggleExpansion(at index: Int) {
        faqs[index].isExpanded.toggle()
    }
}
