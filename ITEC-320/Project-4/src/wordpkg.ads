-- This Ada package body gives the implementation for the word abstract
-- data type.  A word is considered to be any consecutive sequence of
-- non-white-space characters.

WITH Ada.Text_IO;
USE Ada.Text_IO;

PACKAGE WordPkg IS

   TYPE Word IS PRIVATE;

   WordTooLong : EXCEPTION;

   -- Creates a new word corresponding to the given string.
   FUNCTION New_Word (
         Item : String)
     RETURN Word;

   -- Turns a Word into a String
   FUNCTION To_String (
         Item : Word)
     RETURN String;

   -- Indicates the number of characters in a word.
   FUNCTION Length (
         Item : Word)
     RETURN Natural;

   -- Returns the maximum word size supported by this package.
   FUNCTION Max_Word_Size RETURN Positive;

   -- Word comparison functions.  The dictionary lexiographic ordering
   -- is used to determine when one word is less than another.

   FUNCTION "=" (
         X,
         Y : Word)
     RETURN Boolean;
   FUNCTION "<=" (
         X,
         Y : Word)
     RETURN Boolean;
   FUNCTION "<" (
         X,
         Y : Word)
     RETURN Boolean;
   FUNCTION ">=" (
         X,
         Y : Word)
     RETURN Boolean;
   FUNCTION ">" (
         X,
         Y : Word)
     RETURN Boolean;

   -- I/O routines

   -- Skip any white-space that may preceed the word in the input.
   -- If the word is too long to fit in the representation being
   -- used, then raise the WordTooLong exception after the characters
   -- of the word have been read (though not stored).
   PROCEDURE Get (
         File :        File_Type;
         Item :    OUT Word);
   PROCEDURE Get (
         Item :    OUT Word);

   -- Write only those characters that make up the word.
   PROCEDURE Put (
         File : File_Type;
         Item : Word);
   PROCEDURE Put (
         Item : Word);

PRIVATE
   MaxWordSize : CONSTANT Natural := 80;

   TYPE Word IS
      RECORD
         Letters : String (1 .. MaxWordSize);
         Length  : Natural RANGE 0 .. MaxWordSize := 0;
      END RECORD;

END WordPkg;