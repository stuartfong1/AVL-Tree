final int INSERT_TEXTBOX_X = 75;
final int DELETE_TEXTBOX_X = 200;
final int FIND_TEXTBOX_X = 325;
final int MIN_BUTTON_X = 500;
final int MAX_BUTTON_X = 625;
final int TEXTBOX_Y = 400;
final int TEXTBOX_WIDTH = 100;
final int TEXTBOX_HEIGHT = 30;

Node root = null;
String insertText = "";
String deleteText = "";
String findText = "";
String outputText = "";
int selected = -1;

class Node
{
    private int value;
    private int nodeHeight;
    private Node left;
    private Node right;
    
    public Node(int newValue)
    {
        value = newValue;
        nodeHeight = 1;
        left = null;
        right = null;
    }
    
    public int GetValue()
    {
        return value; 
    }
    
    public void SetValue(int newValue)
    {
        value = newValue;
    }
    
    public int GetNodeHeight()
    {
        return nodeHeight;
    }
    
    public void SetNodeHeight()
    {
        int leftNodeHeight = (left == null) ? 0 : left.GetNodeHeight();
        int rightNodeHeight = (right == null) ? 0 : right.GetNodeHeight();
        nodeHeight = ((leftNodeHeight > rightNodeHeight) ? leftNodeHeight : rightNodeHeight) + 1;
    }
    
    public Node GetLeft()
    {
        return left;
    }
    
    public void SetLeft(Node newLeft)
    {
        left = newLeft; 
    }
    
    public Node GetRight()
    {
        return right;
    }
    
    public void SetRight(Node newRight)
    {
        right = newRight;
    }
    
    // Left rotation of nodes
    Node LeftRotation()
    {
        Node temp = right;
        Node temp2 = temp.GetLeft();
        temp.SetLeft(this);
        right = temp2;
        SetNodeHeight();
        temp.SetNodeHeight();
        return temp;
    }
    
    // Right Rotation of nodes
    Node RightRotation()
    {
        Node temp = left; 
        Node temp2 = temp.GetRight();
        temp.SetRight(this);
        left = temp2;
        SetNodeHeight();
        temp.SetNodeHeight();
        return temp;
    }
    
    // Balance both sides of a node
    int Balance()
    {
        SetNodeHeight();
        int leftNodeHeight = (left == null) ? 0 : left.GetNodeHeight();
        int rightNodeHeight = (right == null) ? 0 : right.GetNodeHeight();
        return leftNodeHeight - rightNodeHeight;
    }
    
    // Balance the nodes after inserting
    Node InsertBalance(int changedValue)
    {
        int balance = Balance();
        // Case 1: left -> left
        if (balance > 1 && changedValue < left.GetValue())
        {
            return RightRotation();
        }
        // Case 2: right -> right
        else if (balance < -1 && changedValue > right.GetValue())
        {
            return LeftRotation();
        }
        // Case 3: left -> right
        else if (balance > 1 && changedValue > left.GetValue())
        {
            left = left.LeftRotation();
            return RightRotation();
        }
        // Case 4: right -> left
        else if (balance < -1 && changedValue < right.GetValue())
        {
            right = right.RightRotation();
            return LeftRotation();
        }
        // Case 5: Already balanced
        return this;
    }
    
    // Balance the nodes after deleting
    Node DeleteBalance()
    {
        int balance = Balance();
        // Case 1: left -> left
        if (balance > 1 && left.Balance() >= 0)
        {
            return RightRotation();
        }
        // Case 2: right -> right
        else if (balance < -1 && right.Balance() <= 0)
        {
            return LeftRotation();
        }
        // Case 3: left -> right
        else if (balance > 1 && left.Balance() < 0)
        {
            left = left.LeftRotation();
            return RightRotation();
        }
        // Case 4: right -> left
        else if (balance < -1 && right.Balance() > 0)
        {
            right = right.RightRotation();
            return LeftRotation();
        }
        // Case 5: Already balanced
        return this;
    }
}

// Insert a node
Node Insert(Node n, int value)
{
    // Start the tree / add the node
    if (n == null) return(new Node(value));

    // Insert the value into the tree
    if (value < n.GetValue()) n.SetLeft(Insert(n.GetLeft(), value));
    else if (value > n.GetValue()) n.SetRight(Insert(n.GetRight(), value));
    // Tree does not contain duplicate values
    else return n;

    return n.InsertBalance(value);
}

// Return the highest value in the tree
Node Max(Node n)
{
    while(n.GetRight() != null) n = n.GetRight();
    return n;
}

// Return the lowest value in the tree
Node Min(Node n)
{
    while (n.GetLeft() != null) n = n.GetLeft();
    return n;
}

// Find a value inside the tree
Node Find(Node n, int value)
{
    // Node not found
    if (n == null) return null;
    // Find node
    else if (value < n.GetValue()) return Find(n.GetLeft(), value);
    else if (value > n.GetValue()) return Find(n.GetRight(), value);
    // Node found
    return n;
}

// Delete a node
Node Delete(Node n, int value)
{
    // Node not found
    if (n == null) return n;
    //find the node to delete
    if (value < n.GetValue()) n.SetLeft(Delete(n.GetLeft(), value));
    else if (value > n.GetValue()) n.SetRight(Delete(n.GetRight(), value));
    // Node found
    else
    {
        // Case 1: Has 2 subtrees
        if (n.GetLeft() != null && n.GetRight() != null)
        {
            Node temp = Max(n.GetLeft());
            n.SetValue(temp.GetValue());
            n.SetLeft(Delete(n.GetLeft(), temp.GetValue()));
        }
        // Case 2: Has 1 subtree
        else if (n.GetLeft() != null || n.GetRight() != null) n = (n.GetLeft() == null) ? n.GetRight() : n.GetLeft();
        // Case 3: Has 0 subtrees
        else return null;
    }
    return n.DeleteBalance();
}
void PrintTree(Node n, int x, int y, int xd, int yd)
{
    if(n != null)
    {
        textSize(12);
        fill(100, 32, 87);
        text(n.GetValue(), x, y);
        if(n.GetLeft() != null)
        {
            line(x+5, y, x-xd+10,  y+yd-10);
            PrintTree(n.GetLeft(), x-xd, y+yd, xd/2, yd+5);
        }
        if(n.GetRight() != null)
        {
            line(x+5, y, x+xd, y+yd-10);
            PrintTree(n.GetRight(), x+xd, y+yd, xd/2, yd+5);
        }
    }
}

void setup()
{
    size(800, 600);
    frameRate(30);
}
void mousePressed()
{
    if(INSERT_TEXTBOX_X <= mouseX  && mouseX <= INSERT_TEXTBOX_X + TEXTBOX_WIDTH
    && TEXTBOX_Y <= mouseY && mouseY <= TEXTBOX_Y + TEXTBOX_HEIGHT)
    {
        selected = 0;
    }
    else if(DELETE_TEXTBOX_X <= mouseX  && mouseX <= DELETE_TEXTBOX_X + TEXTBOX_WIDTH
    && TEXTBOX_Y <= mouseY && mouseY <= TEXTBOX_Y + TEXTBOX_HEIGHT)
    {
        selected = 1;
    }
    else if(FIND_TEXTBOX_X <= mouseX  && mouseX <= FIND_TEXTBOX_X + TEXTBOX_WIDTH
    && TEXTBOX_Y <= mouseY && mouseY <= TEXTBOX_Y + TEXTBOX_HEIGHT)
    {
        selected = 2;
    }
    else if(MIN_BUTTON_X <= mouseX  && mouseX <= MIN_BUTTON_X + TEXTBOX_WIDTH
    && TEXTBOX_Y <= mouseY && mouseY <= TEXTBOX_Y + TEXTBOX_HEIGHT)
    {
        if(root == null)
        {
            outputText = "No data.";
        }
        else
        {
            outputText = "Minimum value is " + Min(root).GetValue() + ".";
        }
    }
    else if(MAX_BUTTON_X <= mouseX  && mouseX <= MAX_BUTTON_X + TEXTBOX_WIDTH
    && TEXTBOX_Y <= mouseY && mouseY <= TEXTBOX_Y + TEXTBOX_HEIGHT)
    {
        if(root == null)
        {
            outputText = "No data.";
        }
        else
        {
            outputText = "Maximum value is " + Max(root).GetValue()+ ".";
        }
    }
}
void keyPressed()
{
    if(selected == 0)
    {
        if(key == '\n')
        {
            outputText = "";
            try
            {
                root = Insert(root, Integer.parseInt(insertText));
                outputText = insertText + " inserted.";
            }
            catch(Exception e)
            {
                outputText = "Invalid input.";
            }
            insertText = "";
        }
        else if(key == '\b' && insertText.length() > 0)
        {
            insertText = insertText.substring(0, insertText.length()-1);
        }
        else
        {
            insertText = insertText + key;
        }
    }
    else if(selected == 1)
    {
        if(key == '\n')
        {
            outputText = "";
            try
            {
                root = Delete(root, Integer.parseInt(deleteText));
                outputText = deleteText + " deleted.";
            }
            catch(Exception e)
            {
                outputText = "Invalid input.";
            }
            deleteText = "";
        }
        else if(key == '\b' && deleteText.length() > 0)
        {
            deleteText = deleteText.substring(0, deleteText.length()-1);
        }
        else
        {
            deleteText = deleteText + key;
        }
    }
    else if(selected == 2)
    {
        if(key == '\n')
        {
            outputText = "";
            try
            {
                if(Find(root, Integer.parseInt(findText)) == null)
                {
                    outputText = findText + " not found.";
                }
                else
                {
                    outputText = findText + " found.";
                }
            }
            catch(Exception e)
            {
                outputText = "Invalid input.";
            }
            findText = "";
        }
        else if(key == '\b' && findText.length() > 0)
        {
            findText = findText.substring(0, findText.length()-1);
        }
        else
        {
            findText = findText + key;
        }
    }
}
void draw()
{
    background(240);
    
    fill(0);
    if(root == null)
    {
        textSize(18);
        text("Instructions", 100, 50);
        textSize(12);
        text("To insert a value, enter the value into the \"Insert\" textbox.\n" +
             "To delete a value, enter the value into the \"Delete\" textbox.\n" +
             "To find whether a value is in the tree, enter it into the \"Find\" textbox.\n" +
             "To find the maximum/minimum value, press one of the buttons.", 100, 80);
    }
    textSize(12);
    
    // Insert Textbox
    fill(0);
    text("Insert", INSERT_TEXTBOX_X+30, TEXTBOX_Y-10);
    fill(255);
    rect(INSERT_TEXTBOX_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT);
    fill(0);
    text(insertText, INSERT_TEXTBOX_X+10, TEXTBOX_Y + TEXTBOX_HEIGHT-10);
    
    // Delete Textbox
    fill(0);
    text("Delete", DELETE_TEXTBOX_X+30, TEXTBOX_Y-10);
    fill(255);
    rect(DELETE_TEXTBOX_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT);
    fill(0);
    text(deleteText, DELETE_TEXTBOX_X+10, TEXTBOX_Y + TEXTBOX_HEIGHT-10);
    
    // Find Textbox
    fill(0);
    text("Find", FIND_TEXTBOX_X+30, TEXTBOX_Y-10);
    fill(255);
    rect(FIND_TEXTBOX_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT);
    fill(0);
    text(findText, FIND_TEXTBOX_X+10, TEXTBOX_Y + TEXTBOX_HEIGHT-10);
    
    // Min Button
    fill(225);
    rect(MIN_BUTTON_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT);
    fill(0);
    text("Min", MIN_BUTTON_X+35, TEXTBOX_Y + TEXTBOX_HEIGHT-10);
    
    // Max Button
    fill(225);
    rect(MAX_BUTTON_X, TEXTBOX_Y, TEXTBOX_WIDTH, TEXTBOX_HEIGHT);
    fill(0);
    text("Max", MAX_BUTTON_X+35, TEXTBOX_Y + TEXTBOX_HEIGHT-10);
    
    textSize(16);
    text(outputText, 300, 500);
    
    PrintTree(root, 390, 50, 200, 50);
}
