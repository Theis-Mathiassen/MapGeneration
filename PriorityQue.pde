class PriorityQueue<T> {
    ArrayList<T> heap;
    java.util.Comparator<T> comparator;

    public PriorityQueue(java.util.Comparator<T> comparator) {
        this.heap = new ArrayList<T>();
        this.comparator = comparator;
    }

    public void add(T element) {
        heap.add(element);
        int childIndex = heap.size() - 1;
        int parentIndex = (childIndex - 1) / 2;

        while (childIndex > 0 && comparator.compare(heap.get(childIndex), heap.get(parentIndex)) < 0) {
            T tmp = heap.get(childIndex);
            heap.set(childIndex, heap.get(parentIndex));
            heap.set(parentIndex, tmp);

            childIndex = parentIndex;
            parentIndex = (childIndex - 1) / 2;
        }
    }

    public T poll() {
        if (heap.isEmpty()) {
            return null;
        }

        T min = heap.get(0);

        int lastChildIndex = heap.size() - 1;
        heap.set(0, heap.get(lastChildIndex));
        heap.remove(lastChildIndex);

        int parentIndex = 0;
        int leftChildIndex = parentIndex * 2 + 1;
        int rightChildIndex = parentIndex * 2 + 2;

        while (leftChildIndex < heap.size()) {
            int minChildIndex = leftChildIndex;

            if (rightChildIndex < heap.size() && comparator.compare(heap.get(rightChildIndex), heap.get(leftChildIndex)) < 0) {
                minChildIndex = rightChildIndex;
            }

            if (comparator.compare(heap.get(minChildIndex), heap.get(parentIndex)) < 0) {
                T tmp = heap.get(minChildIndex);
                heap.set(minChildIndex, heap.get(parentIndex));
                heap.set(parentIndex, tmp);

                parentIndex = minChildIndex;
                leftChildIndex = parentIndex * 2 + 1;
                rightChildIndex = parentIndex * 2 + 2;
            } else {
                break;
            }
        }

        return min;
    }

    public boolean isEmpty() {
        return heap.isEmpty();
    }

    public int size() {
        return heap.size();
    }
}
