-- This is the generic implementation for a stack
-- abstract data type.

PACKAGE BODY StackPkg IS

   ----------------------------------------------------------
   -- Purpose: tells if the stack is empty
   -- Parameters: s, a stack
   -- Precondition: N/A
   -- Postcondition: a boolean whether or not the stack is empty
   ----------------------------------------------------------
   FUNCTION IsEmpty (
         S : Stack)
     RETURN Boolean IS
   BEGIN
      RETURN S.Top = 0;
   END IsEmpty;

   ----------------------------------------------------------
   -- Purpose: tells if the stack is full
   -- Parameters: s, a stack
   -- Precondition: N/A
   -- Postcondition: a boolean whether or not the stack is full
   ----------------------------------------------------------
   FUNCTION IsFull (
         S : Stack)
     RETURN Boolean IS
   BEGIN
      RETURN S.Top = Size;
   END IsFull;

   ----------------------------------------------------------
   -- Purpose: adds an item on top of the stack
   -- Parameters: Item: the item to be pushed s: the stack to push it on
   -- Precondition: itemtype has been set and s is a stack
   -- Postcondition: an item has been put on top of the stack
   ----------------------------------------------------------
   PROCEDURE Push (
         Item :        ItemType;
         S    : IN OUT Stack) IS
   BEGIN
      IF IsFull(S) THEN
         RAISE Stack_Full;
      ELSE
         S.Top := S.Top + 1;
         S.Elements(S.Top) := Item;
      END IF;
   END Push;

   ----------------------------------------------------------
   -- Purpose: removes an item from the top of the stack
   -- Parameters: s, the stack to have the item removed from
   -- Precondition: s has items in it
   -- Postcondition: an item has been taken off the stack
   ----------------------------------------------------------
   PROCEDURE Pop (
         S : IN OUT Stack) IS
   BEGIN
      IF IsEmpty(S) THEN
         RAISE Stack_Empty;
      ELSE
         S.Top := S.Top - 1;
      END IF;
   END Pop;

   ----------------------------------------------------------
   -- Purpose: returns the item on the top of the stack
   -- Parameters: s: the stack to return the top value of
   -- Precondition: s is a stack
   -- Postcondition: returns the item on top of the stack
   ----------------------------------------------------------
   FUNCTION Top (
         S : Stack)
     RETURN ItemType IS
   BEGIN
      RETURN S.Elements (S.Top);
   END Top;

END StackPkg;