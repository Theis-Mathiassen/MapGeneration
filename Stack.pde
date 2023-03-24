// user defined class for generic stack
class Stack<T> {
 
  // Empty array list
  ArrayList<T> A;
 
  // Constructor of this class
  // To initialize stack
  Stack()
  {
    // Creating array of Size = size
    this.A = new ArrayList<T>();
  }
 
  // Method 1
  // To push generic element into stack
  void push(T X)
  {
    // Creating new element
    A.add(X);
  }
  // Method 2
  // To return topmost element of stack
  T pop()
  {
    // If stack is empty
    if (A.size() == 0) {
 
      // Display message when there are no elements in
      // the stack
      System.out.println("Stack Underflow");
 
      return null;
    }
 
    // else elements are present so
    // return the topmost element
    else {
      T ToReturn = A.get(A.size()-1);
      A.remove(ToReturn);
      return ToReturn;
    }
  }
 
  // Method 4
  // To check if stack is empty or not
  boolean empty() { return A.size() == 0; }
}
