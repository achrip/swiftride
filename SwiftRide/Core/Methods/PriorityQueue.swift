struct PriorityQueue<Element: Hashable> {
    private var elements: [(element: Element, priority: Double)] = []

    mutating func enqueue(_ element: Element, priority: Double) {
        elements.append((element, priority))
        siftUp(from: elements.count - 1)
    }

    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1)
        let item = elements.removeLast()
        siftDown(from: 0)
        return item.element
    }

    func isEmpty() -> Bool {
        return elements.isEmpty
    }

    private mutating func siftUp(from index: Int) {
        var childIndex = index
        let child = elements[childIndex]

        while childIndex > 0 {
            let parentIndex = (childIndex - 1) / 2
            if elements[parentIndex].priority <= child.priority { break }
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
        }

        elements[childIndex] = child
    }

    private mutating func siftDown(from index: Int) {
        var parentIndex = index
        let count = elements.count

        while true {
            let leftChildIndex = 2 * parentIndex + 1
            let rightChildIndex = leftChildIndex + 1
            var first = parentIndex

            if leftChildIndex < count
                && elements[leftChildIndex].priority < elements[first].priority
            {
                first = leftChildIndex
            }
            if rightChildIndex < count
                && elements[rightChildIndex].priority < elements[first].priority
            {
                first = rightChildIndex
            }
            if first == parentIndex { break }

            elements.swapAt(parentIndex, first)
            parentIndex = first
        }
    }
}
