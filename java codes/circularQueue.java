public class Main {
    static int[] items;
    static int front, rear, capacity, nItems;

    public static boolean isEmpty() {
        return nItems == 0;
    }

    public static boolean isFull() {
        return nItems == capacity;
    }

    public static void enqueue(int element) {
        if (isFull()) {
            System.out.println("Queue is full!");
        } else {
            if(rear == capacity-1)
                rear = -1;
            items[++rear] = element;
            nItems++;
            System.out.println("Inserted: " + element);
        }
    }

    public static void dequeue() {
        if (isEmpty()) {
            System.out.println("Queue is empty!");
        } else {
            int element = items[front++];
            
            if (front == capacity) {
                front = 0;
            }
            nItems--;
            System.out.println("Deleted: " + element);
        }
    }

    public static void size() {
        System.out.println("Size: " + nItems);
    }

    public static void peekFront() {
        if (isEmpty()) {
            System.out.println("Queue is empty!");
        } else {
            System.out.println("peekFront: " + items[front]);
        }
    }
    
    public static void peekRear() {
        if (isEmpty()) {
            System.out.println("Queue is empty!");
        } else {
            System.out.println("peekRear: " + items[rear]);
        }
    }

    public static void display() {
        if (isEmpty()) {
            System.out.println("Queue is empty!");
        } else {
            System.out.print("Queue elements are: ");
            int count = 0;
            int i = front;
            while (count < nItems) {
                System.out.print(items[i % capacity] + " ");
                i++;
                count++;
            }
            System.out.println();
        }
}


    public static void main(String[] args) {

        capacity = 5;
        items = new int[capacity];
        front = 0;
        rear = -1;
        nItems = 0;
        

        enqueue(1);
        enqueue(2);
        enqueue(3);
        enqueue(4);
        enqueue(5);
        enqueue(6);
        enqueue(7);

        display();
        peekFront();
        peekRear();
        size();

        dequeue();
        dequeue();

        display();
        peekFront();
        peekRear();
        size();
        
        enqueue(1);
        enqueue(2);
        
        display();
        peekFront();
        peekRear();
        size();
        
        dequeue();
        dequeue();
        dequeue();
        dequeue();
        dequeue();
        dequeue();
        dequeue();
    }
}