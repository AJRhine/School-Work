WITH Ada.Text_IO;
USE Ada.Text_IO;
WITH Ada.Float_Text_IO;
USE Ada.Float_Text_IO;
WITH Ada.Integer_Text_IO;
USE Ada.Integer_Text_IO;

PROCEDURE Hamming IS
   --Subtype Bit is a subtype of integer that is used to represent.
   SUBTYPE Bit IS Integer RANGE 0..1;

   --Type CharArray is used to take in original data.
   TYPE CharArray IS ARRAY (0 .. 17) OF Character;

   --Type BitArray is used to store orginal array but in an array of integers.
   TYPE BitArray IS ARRAY (0 .. 14) OF Bit;

   --Type ExtractedArray is used to hold extracted array.
   TYPE ExtractedArray IS ARRAY (0 .. 12) OF Character;

   --Array that holds extracted array but in an array of integers.
   TYPE Decimal IS ARRAY (0 .. 10) OF Bit;

   --Holds extracted input.
   ExtractArr : ExtractedArray := (OTHERS => '0');

   CorrectedInput : CharArray := (OTHERS => '0');

   --Holds corrected input.--"OriginalInput" is a character array that represents the input data.
   OriginalInput : CharArray := (OTHERS => '0');

   --"FixedInput" is a bit array that represents the input data in an array of integers (originally set to 0).
   FixedInput : BitArray := (OTHERS => 0);

   LastColumn : Integer         := 0;           --Holds decimal version of extracted num.
   BitNumDeci : Integer         := 0;           --holds decimal version of bitnum.
   Count      : Integer         := 0;           --Helps get data from text document.
   BiBitNum   : String (1 .. 4);                --Binary version of Bit Num
   Output1    : String          := "Original";  --Title for the "Original" output column.
   Output2    : String          := "Bit Num";   --Title for the "Bit Num" output column.
   Output3    : String          := "Corrected"; --Title for the "Corrected" output column.
   Output4    : String          := "Extracted"; --Title for the "Extracted" output column.
   Output5    : String          := "Decimal";   --Title for the "Decimal" output column.

   ----------------------------------------------------------
   -- Purpose: Finds error location in 15-bit binary number.
   -- Parameters: Arr: Array of integers that represents
   --                  15-bit binary number from data.
   -- Precondition: Assumes Arr is instantiated.
   -- Postcondition: Returns binary Bit Num in String form.
   ----------------------------------------------------------
   FUNCTION ErrorFinder (
         Arr : BitArray)
     RETURN String IS

      --Type used for mod conversion.
      TYPE Unsigned_Byte IS mod 256;
      --Array of 15-bit binary numbers.
      TYPE ByteArr IS ARRAY (0 .. 14) OF Unsigned_Byte;

      A    : ByteArr;                       --Array of 15-bit binary numbers.
      Zero : Unsigned_Byte := 2#0000_0000#; --Binary zero.
      One  : Unsigned_Byte := 2#0000_0001#; --Binary one.

      Cnt : Integer;       --Iterator for for loop.
      Z1  : Unsigned_Byte; --First number of binary bit num.
      Z2  : Unsigned_Byte; --Second number of binary bit num.
      Z3  : Unsigned_Byte; --Third number of binary bit num.
      Z4  : Unsigned_Byte; --Foruth number of binary bit num.

      Answer : String (1 .. 4);        --Binary bit num in String form.
      S1     : String          := " "; --First number of binary bit num in String form.
      S2     : String          := " "; --Second number of binary bit num in String form.
      S3     : String          := " "; --Third number of binary bit num in String form.
      S4     : String          := " "; --Foruth number of binary bit num in String form.

   BEGIN
      Cnt := 14;

      --Creates Unsigned_Byte array.
      FOR I IN 0..14 LOOP
         IF Arr(I) = 0 THEN
            A(Cnt) := Zero;
            Cnt:= Cnt - 1;
         END IF;
         IF Arr(I) = 1 THEN
            A(Cnt) := One;
            Cnt:= Cnt - 1;
         END IF;
      END LOOP;

      --Handles parity 8
      Z1:= A(14) XOR A(13) XOR A(12) XOR A(11) XOR A(10) XOR A(9) XOR A(8) XOR
         A(7);

      --Handles parity 4
      Z2:= A(14) XOR A(13) XOR A(12) XOR A(11) XOR A(6) XOR A(5) XOR A(4) XOR
         A(3);

      --Handles parity 2
      Z3:= A(14) XOR A(13) XOR A(10) XOR A(9) XOR A(6) XOR A(5) XOR A(2) XOR
         A(1);

      --Handles parity 1
      Z4:= A(14) XOR A(12) XOR A(10) XOR A(8) XOR A(6) XOR A(4) XOR A(2) XOR
         A(0);

      --Converts Unsigned_Byte to String.
      IF Z1 = 0 THEN
         S1 := "0";
      ELSIF Z1 = 1 THEN
         S1 := "1";
      END IF;

      IF Z2 = 0 THEN
         S2 := "0";
      ELSIF Z2 = 1 THEN
         S2 := "1";
      END IF;

      IF Z3 = 0 THEN
         S3 := "0";
      ELSIF Z3 = 1 THEN
         S3 := "1";
      END IF;

      IF Z4 = 0 THEN
         S4 := "0";
      ELSIF Z4 = 1 THEN
         S4 := "1";
      END IF;

      --Creates binary Bit Num in string form for output.
      Answer:= S1 & S2 & S3 & S4;

      RETURN Answer;

   END ErrorFinder;

   ----------------------------------------------------------
   -- Purpose: Converts binary bit num to decimal form.
   -- Parameters: Takes in a bitarray
   --             also has an in out integer.
   -- Precondition: Assumes bit array has been instantiated.
   -- Postcondition: Returns decimal version of bit num.
   ----------------------------------------------------------
   PROCEDURE DecimalConverter (
         Arr    :        BitArray;
         Answer : IN OUT Integer) IS

      --Type used for mod conversion.
      TYPE Unsigned_Byte IS mod 256;

      --Array of 15-bit binary numbers.
      TYPE ByteArr IS ARRAY (0 .. 14) OF Unsigned_Byte;

      --Array of bits that represents bitnum.
      TYPE BitNumArr IS ARRAY (1 .. 4) OF Bit;

      NumArr :          BitNumArr;                     --Holds bit num in decimal form.
      A      :          ByteArr;                       --Array of 15-bit binary numbers.
      Zero   : CONSTANT Unsigned_Byte := 2#0000_0000#; --Binary zero.
      One    : CONSTANT Unsigned_Byte := 2#0000_0001#; --Binary one.

      Count : Integer       := 0; --Iterator for decimal conversion loop.
      Cnt   : Integer       := 0; --Iterator for for loop.
      Z1    : Unsigned_Byte := 0; --First number of binary bit num.
      Z2    : Unsigned_Byte := 0; --Second number of binary bit num.
      Z3    : Unsigned_Byte := 0; --Third number of binary bit num.
      Z4    : Unsigned_Byte := 0; --Foruth number of binary bit num.

      I1 : Bit := 0;
      I2 : Bit := 0;
      I3 : Bit := 0;
      I4 : Bit := 0;

   BEGIN
      Cnt := 14;

      --Creates Unsigned_Byte array.
      FOR I IN 0..14 LOOP
         IF Arr(I) = 0 THEN
            A(Cnt) := Zero;
            Cnt:= Cnt - 1;
         END IF;
         IF Arr(I) = 1 THEN
            A(Cnt) := One;
            Cnt:= Cnt - 1;
         END IF;
      END LOOP;

      --Handles parity 8
      Z1:= A(14) XOR A(13) XOR A(12) XOR A(11) XOR A(10) XOR A(9) XOR A(8) XOR
         A(7);

      --Handles parity 4
      Z2:= A(14) XOR A(13) XOR A(12) XOR A(11) XOR A(6) XOR A(5) XOR A(4) XOR
         A(3);

      --Handles parity 2
      Z3:= A(14) XOR A(13) XOR A(10) XOR A(9) XOR A(6) XOR A(5) XOR A(2) XOR
         A(1);

      --Handles parity 1
      Z4:= A(14) XOR A(12) XOR A(10) XOR A(8) XOR A(6) XOR A(4) XOR A(2) XOR
         A(0);

      IF Z1 = 0 THEN
         I1 := 0;
      ELSIF Z1 = 1 THEN
         I1 := 1;
      END IF;

      IF Z2 = 0 THEN
         I2 := 0;
      ELSIF Z2 = 1 THEN
         I2 := 1;
      END IF;

      IF Z3 = 0 THEN
         I3 := 0;
      ELSIF Z3 = 1 THEN
         I3 := 1;
      END IF;

      IF Z4 = 0 THEN
         I4 := 0;
      ELSIF Z4 = 1 THEN
         I4 := 1;
      END IF;

      NumArr(1) := I1;
      NumArr(2) := I2;
      NumArr(3) := I3;
      NumArr(4) := I4;

      --Decimal conversion of bit num.
      FOR I IN REVERSE 1 .. 4 LOOP
         Answer:= Answer + (NumArr(I) * (2**(Count)));
         Count := Count + 1;
      END LOOP;
   END DecimalConverter;

   ----------------------------------------------------------
   -- Purpose: Converts data to corrected data.
   -- Parameters: Takes in integer which represents the integer
   --             that needs to be changed.
   --             Takes in bit array that represents original
   --             data.
   -- Precondition: Assumes bit array has been instantiated.
   -- Postcondition: Returns corrected data.
   ----------------------------------------------------------
   FUNCTION CorrectedData (
         Num : Integer;
         Arr : BitArray)
     RETURN CharArray IS
      Answer  : CharArray;
      TempArr : BitArray;
      Replace : Integer;
   BEGIN
      Replace:= 15 - Num;
      FOR I IN Arr'First..Arr'Last LOOP
         TempArr(I) := Arr(I);
      END LOOP;

      IF Num /= 0 THEN
         IF Arr(Replace) = 0 THEN
            TempArr(Replace) := 1;
         ELSIF Arr(Replace) = 1 THEN
            TempArr(Replace) := 0;
         END IF;
      END IF;


      FOR I IN 0..2 LOOP
         IF TempArr(I) = 0 THEN
            Answer(I) := '0';
         ELSIF TempArr(I) = 1 THEN
            Answer(I) := '1';
         END IF;
      END LOOP;

      Answer(3) := ' ';

      FOR I IN 3..6 LOOP
         IF TempArr(I) = 0 THEN
            Answer(I+1) := '0';
         ELSIF TempArr(I) = 1 THEN
            Answer(I+1) := '1';
         END IF;
      END LOOP;

      Answer(8):= ' ';

      FOR I IN 7..10 LOOP
         IF TempArr(I) = 0 THEN
            Answer(I+2) := '0';
         ELSIF TempArr(I) = 1 THEN
            Answer(I+2) := '1';
         END IF;
      END LOOP;

      Answer(13):= ' ';

      FOR I IN 11..14 LOOP
         IF TempArr(I) = 0 THEN
            Answer(I+3) := '0';
         ELSIF TempArr(I) = 1 THEN
            Answer(I+3) := '1';
         END IF;
      END LOOP;

      RETURN Answer;
   END CorrectedData;

   ----------------------------------------------------------
   -- Purpose: Creates exctracted data.
   -- Parameters: CharArray represents corrected data.
   -- Precondition: Assumes charArray has been instantiated.
   -- Postcondition: Returns extracted data.
   ----------------------------------------------------------
   FUNCTION ExtractedData (
         Arr : CharArray)
     RETURN ExtractedArray IS
      Answer : ExtractedArray;
      I      : Integer        := 0;
      J      : Integer        := 0;
      K      : Integer        := 0;
   BEGIN

      WHILE I < 17 LOOP
         IF I = 9 THEN
            K:= K + 1;
         ELSIF I = 13 THEN
            K:= K + 1;
         ELSIF I = 14 THEN
            K:= K + 1;
         ELSIF I = 16 THEN
            K:= K + 1;
         ELSE
            Answer(J) := Arr(I);
            J:= J + 1;
         END IF;
         I:= I + 1;
      END LOOP;
      RETURN Answer;
   END ExtractedData;

   ----------------------------------------------------------
   -- Purpose: Prints Final Decimal
   -- Parameters: Array of exctracted data.
   -- Precondition: Assumes extractedArray has been instantiated.
   -- Postcondition: Returns decimal form of extracted array.
   ----------------------------------------------------------
   FUNCTION FinalDecimal (
         Arr : ExtractedArray)
     RETURN Integer IS
      Answer : Integer := 0;
      NumArr : Decimal;
      Count  : Integer := 0;
      Count2 : Integer := 0;
   BEGIN
      FOR I IN 0..12 LOOP
         IF Arr(I) = '0' THEN
            NumArr(Count) := 0;
            Count:= Count + 1;
         ELSIF Arr(I) = '1' THEN
            NumArr(Count) := 1;
            Count:= Count + 1;
         END IF;
      END LOOP;

      --Does decimal conversion for final column.
      FOR I IN REVERSE 0 .. 10 LOOP
         Answer:= Answer + (NumArr(I) * (2**(Count2)));
         Count2 := Count2 + 1;
      END LOOP;
      RETURN Answer;
   END FinalDecimal;

BEGIN
   --Prints the column titles.
   Put_Line("     " & Output1 & "        "
      & Output2 & "       " & Output3 & "          " & Output4 & "    "&
      Output5);

   --This while loops reads the file and takes care
   --of the output for the program.
   WHILE NOT End_Of_File LOOP
      Count := 0;

      FOR I IN 0..17 LOOP
         --Gets input from the file and stores the data as an array of characters.
         Get(OriginalInput(I));

         --These if statements set the the values of "FixedArray".
         IF OriginalInput(I) = '0' THEN
            FixedInput(Count) := 0;
            Count := Count + 1;
         ELSIF OriginalInput(I) = '1' THEN
            FixedInput(Count) := 1;
            Count := Count + 1;
         END IF;
      END LOOP;

      --This for loop prints the original data.
      FOR I IN 0..17 LOOP
         Put(OriginalInput(I));
      END LOOP;
      Put(" : ");

      --Finds and prints Bit Nums.
      BiBitNum := ErrorFinder(FixedInput);
      Put(BiBitNum);
      Put(" ");
      DecimalConverter(FixedInput, BitNumDeci);
      Put(BitNumDeci , 2);
      Put(" : ");

      --Prints corrected data.
      CorrectedInput:= CorrectedData(BitNumDeci, FixedInput);
      FOR I IN 0..17 LOOP
         Put(CorrectedInput(I));
      END LOOP;
      Put(" : ");

      --Prints extracted data.
      ExtractArr:= ExtractedData(CorrectedInput);
      FOR I IN 0..12 LOOP
         Put(ExtractArr(I));
      END LOOP;
      Put(" : ");

      --Prints last coulumn
      LastColumn:= FinalDecimal(ExtractArr);
      Put(LastColumn, 4);
      New_Line;
      BitNumDeci:= 0;
   END LOOP;

END Hamming;



