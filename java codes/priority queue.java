public class Main
{
    static int[] items;
    static int capacity, nItems;

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
            int j;
            if(isEmpty()){
                items[nItems++] = element;
                System.out.println("Inserted: " + element);
            }else{
                for(j = nItems - 1; j>=0; j--){
                    if(element > items[j])
                        items[j+1] = items[j];
                    else
                        break;
                }
                items[j+1] = element;
                nItems++;
                System.out.println("Inserted: " + element);
            }
        }
    }

    public static void dequeue() {
        if (isEmpty()) {
            System.out.println("Queue is empty!");
        } else {
            int element = items[0];
            for (int i = 0; i < nItems - 1; i++) {
                items[i] = items[i + 1];
            }
            nItems--;
            System.out.println("Deleted: " + element);
        }
    }


    public static void size(){
        System.out.println("Size: "+ nItems);
    }

    public static void peekMin(){
        if (isEmpty()) {
            System.out.println("Queue is empty!");

        } else {
            System.out.println("peekMin: " + items[nItems-1]);
        }
    }
    
    public static void peekMax(){
        if (isEmpty()) {
            System.out.println("Queue is empty!");

        } else {
            System.out.println("peekMax: " + items[0]);
        }
    }
    

    public static void display() {
        if (isEmpty()) {
            System.out.println("Queue is empty!");
        } else {
            System.out.print("Queue: ");
            for (int i = 0; i < nItems; i++) {
                System.out.print(items[i] + " ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        
        capacity = 5;
        items = new int[capacity]; 
        nItems = 0;

        enqueue(5);
        enqueue(3);
        enqueue(1);
        enqueue(4);
        enqueue(7);
        enqueue(6);
        enqueue(8);

        display();
        peekMax();
        peekMin();
        size();

        dequeue();
        dequeue();

        display();
        peekMax();
        peekMin();
        size();
        
        enqueue(13);
        enqueue(1);
        
        display();
        peekMax();
        peekMin();
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