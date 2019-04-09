-- This is the generic specification for a stack abstract data type.
-- Usage: Put these lines in the client (in the appropriate place):

--    with StackPkg;   -- this statement precedes client procedure declaration
--
--                     -- the next 2 statements go inside the client procedure
--                     -- the next 2 statements go after MyType is declared
--    package MyStkPkg is new StackPkg(Size => 100; ItemType => MyType);
--    use  MyStkPkg;

GENERIC  -- Generic parameters are declared here

   Size : Positive; -- Size of stack to create

   TYPE ItemType IS PRIVATE;  -- Type of elements that stack will contain

PACKAGE StackPkg IS

   TYPE Stack IS LIMITED PRIVATE;

   Stack_Empty: EXCEPTION; -- Raised if do top or pop on an empty stack
   Stack_Full : EXCEPTION; -- Raised if push onto full stack

   -- Determine if stack is empty or full
   FUNCTION IsEmpty (
         S : Stack)
     RETURN Boolean;
   FUNCTION IsFull (
         S : Stack)
     RETURN Boolean;

   -- Put element Item onto Stack s
   PROCEDURE Push (
         Item :        ItemType;
         S    : IN OUT Stack) WITH Pre => NOT IsFull (
         S) OR ELSE RAISE Stack_Full;

   -- Remove an element from Stack s
   PROCEDURE Pop (
         S : IN OUT Stack) WITH Pre => NOT IsEmpty (
         S) OR ELSE RAISE Stack_Empty;

   -- Return top element from Stack s
   FUNCTION Top (
         S : Stack)
     RETURN ItemType WITH Pre => NOT IsEmpty (
         S) OR ELSE RAISE Stack_Empty;

PRIVATE

   TYPE StackElements IS ARRAY (1 .. Size) OF ItemType;

   TYPE Stack IS
      RECORD
         Elements : StackElements;
         Top      : Natural RANGE 0 .. Size := 0;
      END RECORD;

END StackPkg;