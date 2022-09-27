
struct LinkedList<T> {
    var head: LinkedListNode<T>
    init(head: LinkedListNode<T>) {
        self.head = head
    }
}

indirect enum LinkedListNode<T> {
    case value(element: T, next: LinkedListNode<T>)
    case end
}

extension LinkedList: Sequence {
    func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator(current: head)
    }
}

struct LinkedListIterator<T>: IteratorProtocol {
    var current: LinkedListNode<T>

    mutating func next() -> T? {
        switch current {
        case let .value(element, next):
            current = next
            return element
        case .end: return nil
        }
    }
}

let element5 = LinkedListNode.value(element: "f", next: .end)
let element4 = LinkedListNode.value(element: "c", next: element5)
let element3 = LinkedListNode.value(element: "d", next: element4)
let element2 = LinkedListNode.value(element: "b", next: element3)
let element1 = LinkedListNode.value(element: "a", next: element2)
let list = LinkedList(head: element1)

print(list.reversed())
