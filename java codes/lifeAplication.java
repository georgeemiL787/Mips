public class Main {
    static int maxSize; 
    static int[] queueArray;
    static int front; 
    static int rear; 
    static int currentSize; 

    public static boolean isEmpty() {
        return currentSize == 0;
    }

    public static boolean isFull() {
        return currentSize == maxSize;
    }

    public static void enqueue(int data) {
        if (isFull()) {
            System.out.println("Queue is full. Cannot enqueue.");
            return;
        }
        rear = (rear + 1) % maxSize; 
        queueArray[rear] = data;
        currentSize++;
        System.out.println("Customer added to the queue.");
    }

    public static int dequeue() {
        if (isEmpty()) {
            System.out.println("Queue is empty. Cannot dequeue.");
            return -1;
        }
        int removedItem = queueArray[front];
        front = (front + 1) % maxSize; 
        currentSize--;
        System.out.println("Customer served and removed from the queue.");
        return removedItem;
    }

    public static void displayQueue() {
        if (isEmpty()) {
            System.out.println("Queue is empty.");
            return;
        }
        System.out.println("Current Queue:");
        for (int i = 0; i < currentSize; i++) {
            int index = (front + i) % maxSize; 
            System.out.println("Customer " + (i + 1) + ": " + queueArray[index]);
        
    }
}

    public static void main(String[] args) {

        maxSize = 5;
        queueArray = new int[maxSize];
        front = 0;
        rear = -1;
        currentSize = 0;
        
        enqueue(101);
        enqueue(102);
        enqueue(103);

        displayQueue();

        int servedCustomer = dequeue();
        System.out.println("Customer served: " + servedCustomer);

        displayQueue();
    }

}