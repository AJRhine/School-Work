WITH Ada.Text_IO;
USE Ada.Text_IO;
WITH Ada.Float_Text_IO;
USE Ada.Float_Text_IO;
WITH Ada.Integer_Text_IO;
USE Ada.Integer_Text_IO;

PROCEDURE Ham2 IS

   --Represents binary numbers.
   SUBTYPE Bit IS Integer RANGE 0..1;

   --Represents parity bits.
   TYPE ParityBitArr IS ARRAY (1 .. 4) OF Bit;

   --Represents 15 bit Number.
   TYPE Bit15Num IS ARRAY (0 .. 14) OF Bit;

   --Represents 11 bit Number.
   TYPE Bit11Num IS ARRAY (0 .. 10) OF Bit;

   --Type used for mod conversion.
   TYPE Unsigned_Byte IS mod 256;

   --Array of 15-bit binary numbers.
   TYPE ByteArr15 IS ARRAY (0 .. 14) OF Unsigned_Byte;

   TYPE ByteArr11 IS ARRAY (0 .. 10) OF Unsigned_Byte;

   TYPE Bit_Kind IS
         (Bit11,
          Bit15);

   TYPE BitRecord(Bit_Type: Bit_Kind := Bit11) IS
   RECORD
      CASE Bit_Type IS

         WHEN Bit11 =>
            Original_11Bit: String(1 .. 13); --Input Data
            BitNum_11Bit: String(1 .. 7); --Bit Num of Input Data
            Corrected_11Bit: String(1 .. 18); --Corrected Input
            Extracted_11Bit: String(1 .. 13); --Extracted data
            Deci_11Bit: Integer; --Bin Num of Extracted data

         WHEN Bit15 =>
            Original_15Bit: String(1 .. 18); --Input Data
            BitNum_15Bit: String(1 .. 7); --Bit Num of Input Data
            Corrected_15Bit: String(1 .. 18); --Corrected Input
            Extracted_15Bit: String(1 .. 13); --Extracted data
            Deci_15Bit: Integer; --Bin Num of Extracted data

      END CASE;
   END RECORD;

   TYPE CorrectedDataArr IS ARRAY (0 .. 1000) OF BitRecord;

   ----------------------------------------------------------
   -- Purpose: Removes underscores from input
   -- Parameters: String: a line of input in string form
   -- Precondition: Assumes the string is not empty
   -- Postcondition: returns a the input with no underscores
   ----------------------------------------------------------
   FUNCTION NoUnderScore (
         Str : String)
     RETURN String IS

      FifteenBit : CONSTANT Natural := 18; --Size of 15 bit number with underscores
      ElevenBit  : CONSTANT Natural := 13; --Size of 11 bit number with underscores

      Answer         : String (1 .. 20) := (OTHERS => '0'); --Returned variable
      Count          : Integer          := 1;               --Index for traversing answer string
      FixedStrLength : Integer          := 0;               --Represents size of input string

   BEGIN
      IF Str'Length = FifteenBit THEN
         FixedStrLength:= 15;
      END IF;
      IF Str'Length = ElevenBit THEN
         FixedStrLength:= 11;
      END IF;

      FOR I IN 1 .. Str'Length LOOP
         IF Str(I) = '0' THEN
            Answer(Count):= Str(I);
            Count:= Count + 1;
         END IF;
         IF Str(I) = '1' THEN
            Answer(Count):= Str(I);
            Count:= Count + 1;
         END IF;
      END LOOP;

      DECLARE
         FixedAnswer : String (1 .. FixedStrLength) := (OTHERS => '0');
      BEGIN

         FOR I IN 1 .. FixedAnswer'Length LOOP
            FixedAnswer(I):= Answer(I);
         END LOOP;

         RETURN FixedAnswer;
      END;

   END NoUnderScore;


   --------------------------------------------------------
   -- Purpose: Determines no errors section of output
   -- Parameters: String: a line of input in string form
   -- Precondition: Assumes the string is not empty
   -- Postcondition: returns 15 bit number in
   --                unbound_String form
   --------------------------------------------------------
   FUNCTION NoErrors (
         Str : String)
     RETURN String IS

      FifteenBit : CONSTANT Natural       := 18;           --Size of 15 bit number with underscores
      ElevenBit  : CONSTANT Natural       := 13;           --Size of 11 bit number with underscores
      Zero       : CONSTANT Unsigned_Byte := 2#0000_0000#; --Binary zero.
      One        : CONSTANT Unsigned_Byte := 2#0000_0001#; --Binary one.

      Answer         : String (1 .. 18);                             --converts finalStr to Unbound_Str
      NumArr         : ParityBitArr;                                 --Array of parity bits
      Parity8Num     : Unsigned_Byte;                                --Bit representing parity 8 used for XOR function
      Parity4Num     : Unsigned_Byte;                                --Bit representing parity 4 used for XOR function
      Parity2Num     : Unsigned_Byte;                                --Bit representing parity 2 used for XOR function
      Parity1Num     : Unsigned_Byte;                                --Bit representing parity 1 used for XOR function
      Parity8        : Bit                      := 0;                --Bit representing parity 8
      Parity4        : Bit                      := 0;                --Bit representing parity 4
      Parity2        : Bit                      := 0;                --Bit representing parity 2
      Parity1        : Bit                      := 0;                --Bit representing parity 1
      HammingDecimal : Integer                  := 0;                --Decimal version of the parity bits
      Exponent       : Integer                  := 0;                --Used to keep track of exponent number
      J              : Integer                  := 0;                --Index for traversing FixedStr15
      Num            : Integer                  := 14;               --Index for traversing 15 bit number
      Num2           : Integer                  := 10;               --Index for traversing 11 bit number
      Replace        : Integer                  := 0;                --Represents which number position that should be replaced
      FinalStr       : String (1 .. Str'Length) := Str;              --Represents final answer in string for.
      BitNumArr11    : ByteArr11                := (OTHERS => Zero); --11 bit array
      BitNumArr15    : ByteArr15                := (OTHERS => Zero); --15 bit array
      FixedStr15     : String (1 .. 15)         := (OTHERS => '0');  --Holds 15 bit number String without underscores
      FixedStr11     : String (1 .. 11)         := (OTHERS => '0');  --Holds 11 bit number String without underscores
      FinalStr11     : String (1 .. FifteenBit) := (OTHERS => '0');  --Holds 11 bit number String with underscores

   BEGIN

      --This if statement handles 15 Bit numbers
      IF Str'Length = FifteenBit THEN

         FixedStr15:= NoUnderScore(Str);

         FOR I IN FixedStr15'RANGE LOOP
            IF FixedStr15(I) = '0' THEN
               BitNumArr15(Num) := Zero;
               Num:= Num - 1;
            END IF;
            IF FixedStr15(I) = '1' THEN
               BitNumArr15(Num) := One;
               Num:= Num - 1;
            END IF;
         END LOOP;

         --Parity 8
         Parity8Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
            BitNumArr15(12) XOR BitNumArr15(11) XOR BitNumArr15(10) XOR
            BitNumArr15(9) XOR BitNumArr15(8) XOR BitNumArr15(7);

         --Parity 4
         Parity4Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
            BitNumArr15(12) XOR BitNumArr15(11) XOR BitNumArr15(6) XOR
            BitNumArr15(5) XOR BitNumArr15(4) XOR BitNumArr15(3);

         --Parity 2
         Parity2Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
            BitNumArr15(10) XOR BitNumArr15(9) XOR BitNumArr15(6) XOR
            BitNumArr15(5) XOR BitNumArr15(2) XOR BitNumArr15(1);

         --Parity 1
         Parity1Num:= BitNumArr15(14) XOR BitNumArr15(12) XOR
            BitNumArr15(10) XOR BitNumArr15(8) XOR BitNumArr15(6) XOR
            BitNumArr15(4) XOR BitNumArr15(2) XOR BitNumArr15(0);

         IF Parity8Num = 0 THEN
            Parity8 := 0;
         ELSIF Parity8Num = 1 THEN
            Parity8 := 1;
         END IF;

         IF Parity4Num = 0 THEN
            Parity4 := 0;
         ELSIF Parity4Num = 1 THEN
            Parity4 := 1;
         END IF;

         IF Parity2Num = 0 THEN
            Parity2 := 0;
         ELSIF Parity2Num = 1 THEN
            Parity2 := 1;
         END IF;

         IF Parity1Num = 0 THEN
            Parity1 := 0;
         ELSIF Parity1Num = 1 THEN
            Parity1 := 1;
         END IF;

         NumArr(1) := Parity8;
         NumArr(2) := Parity4;
         NumArr(3) := Parity2;
         NumArr(4) := Parity1;

         FOR I IN REVERSE 1 .. 4 LOOP
            HammingDecimal:= HammingDecimal + (NumArr(I) * (2**(Exponent)));
            Exponent := Exponent + 1;
         END LOOP;

         Replace:= HammingDecimal;

         IF HammingDecimal /= 0 THEN
            FOR I IN REVERSE 1 .. 15 LOOP
               IF Replace - 1 = J THEN
                  IF FixedStr15(I) = '0' THEN
                     FixedStr15(I) := '1';
                  ELSIF FixedStr15(I) = '1' THEN
                     FixedStr15(I) := '0';
                  END IF;
               END IF;
               J := J + 1;
            END LOOP;
         END IF;

         FinalStr(1):= FixedStr15(1);
         FinalStr(2):= FixedStr15(2);
         FinalStr(3):= FixedStr15(3);
         FinalStr(4):= '_';
         FinalStr(5):= FixedStr15(4);
         FinalStr(6):= FixedStr15(5);
         FinalStr(7):= FixedStr15(6);
         FinalStr(8):= FixedStr15(7);
         FinalStr(9):= '_';
         FinalStr(10):= FixedStr15(8);
         FinalStr(11):= FixedStr15(9);
         FinalStr(12):= FixedStr15(10);
         FinalStr(13):= FixedStr15(11);
         FinalStr(14):= '_';
         FinalStr(15):= FixedStr15(12);
         FinalStr(16):= FixedStr15(13);
         FinalStr(17):= FixedStr15(14);
         FinalStr(18):= FixedStr15(15);

         Answer:= FinalStr;
      END IF;

      --This if statement handles 11 Bit numbers
      IF Str'Length = ElevenBit THEN

         FixedStr11:= NoUnderScore(Str);

         FOR I IN FixedStr11'RANGE LOOP
            IF FixedStr11(I) = '0' THEN
               BitNumArr11(Num2) := Zero;
               Num2:= Num2 - 1;
            END IF;
            IF FixedStr11(I) = '1' THEN
               BitNumArr11(Num2) := One;
               Num2:= Num2 - 1;
            END IF;
         END LOOP;

         --Handles parity 8
         Parity8Num:= BitNumArr11(10) XOR BitNumArr11(9) XOR
            BitNumArr15(8) XOR BitNumArr11(7) XOR BitNumArr11(6) XOR
            BitNumArr15(5) XOR BitNumArr11(4);

         --Handles parity 4
         Parity4Num:= BitNumArr11(10) XOR BitNumArr11(9) XOR
            BitNumArr11(8) XOR BitNumArr11(7) XOR BitNumArr11(3) XOR
            BitNumArr11(2) XOR BitNumArr11(1);

         --Handles parity 2
         Parity2Num:= BitNumArr11(10) XOR BitNumArr11(9) XOR
            BitNumArr11(6) XOR BitNumArr11(5) XOR BitNumArr11(3) XOR
            BitNumArr11(2) XOR BitNumArr11(0);

         --Handles parity 1
         Parity1Num:= BitNumArr11(10) XOR BitNumArr11(8) XOR
            BitNumArr11(6) XOR BitNumArr11(4) XOR BitNumArr11(3) XOR
            BitNumArr11(1) XOR BitNumArr11(0);

         IF Parity8Num = 0 THEN
            FixedStr15(8):= '0';
         ELSIF Parity8Num = 1 THEN
            FixedStr15(8):= '1';
         END IF;

         IF Parity4Num = 0 THEN
            FixedStr15(4):= '0';
         ELSIF Parity4Num = 1 THEN
            FixedStr15(4):= '1';
         END IF;

         IF Parity2Num = 0 THEN
            FixedStr15(2):= '0';
         ELSIF Parity2Num = 1 THEN
            FixedStr15(2):= '1';
         END IF;

         IF Parity1Num = 0 THEN
            FixedStr15(1):= '0';
         ELSIF Parity1Num = 1 THEN
            FixedStr15(1):= '1';
         END IF;

         FixedStr15(15):= FixedStr11(1);
         FixedStr15(14):= FixedStr11(2);
         FixedStr15(13):= FixedStr11(3);
         FixedStr15(12):= FixedStr11(4);
         FixedStr15(11):= FixedStr11(5);
         FixedStr15(10):= FixedStr11(6);
         FixedStr15(9):= FixedStr11(7);
         FixedStr15(7):= FixedStr11(8);
         FixedStr15(6):= FixedStr11(9);
         FixedStr15(5):= FixedStr11(10);
         FixedStr15(3):= FixedStr11(11);

         FinalStr11(1):= FixedStr15(15);
         FinalStr11(2):= FixedStr15(14);
         FinalStr11(3):= FixedStr15(13);
         FinalStr11(4):= '_';
         FinalStr11(5):= FixedStr15(12);
         FinalStr11(6):= FixedStr15(11);
         FinalStr11(7):= FixedStr15(10);
         FinalStr11(8):= FixedStr15(9);
         FinalStr11(9):= '_';
         FinalStr11(10):= FixedStr15(8);
         FinalStr11(11):= FixedStr15(7);
         FinalStr11(12):= FixedStr15(6);
         FinalStr11(13):= FixedStr15(5);
         FinalStr11(14):= '_';
         FinalStr11(15):= FixedStr15(4);
         FinalStr11(16):= FixedStr15(3);
         FinalStr11(17):= FixedStr15(2);
         FinalStr11(18):= FixedStr15(1);

         Answer:= FinalStr11;
      END IF;

      RETURN Answer;
   END NoErrors;

   ----------------------------------------------------------
   -- Purpose: Determines the extracted data for output.
   -- Parameters: String: a line of input in string form
   -- Precondition: Assumes the string is not empty
   -- Postcondition: Returns an 11bit number
   ----------------------------------------------------------
   FUNCTION Extracted (
         Str : String)
     RETURN String IS

      FifteenBit : CONSTANT Natural := 18; --Size of 15 bit number with underscores
      ElevenBit  : CONSTANT Natural := 13; --Size of 11 bit number with underscores

      Answer15Bit      : String (1 .. 13)         := (OTHERS => '0');
      Answer11Bit      : String (1 .. 13)         := (OTHERS => '0'); --Returned value that represents extracted data
      CorrectedUnbound : String (1 .. 18);                            --Holds corrected version of input
      CorrectedIndex   : Integer                  := 1;               --Index used for traversing corrected data
      AnswerIndex      : Integer                  := 1;               --Index used for traversing answer data
      CorrectedStr     : String (1 .. FifteenBit) := (OTHERS => '0'); --Holds input parameter Str
      AnswerStr        : String (1 .. ElevenBit)  := (OTHERS => '0'); --Converts CorrectedUnbound to Unbounded_String

   BEGIN

      --This if statement handles 15 Bit numbers
      IF Str'Length = FifteenBit THEN
         CorrectedUnbound:= NoErrors(Str);
         CorrectedStr:= CorrectedUnbound;

         WHILE CorrectedIndex < 18 LOOP
            IF CorrectedIndex = 10 THEN
               NULL; --Do nothing
            ELSIF CorrectedIndex = 14 THEN
               NULL; --Do nothing
            ELSIF CorrectedIndex = 15 THEN
               NULL; --Do nothing
            ELSIF CorrectedIndex = 17 THEN
               NULL; --Do nothing
            ELSE
               AnswerStr(AnswerIndex) := CorrectedStr(CorrectedIndex);
               AnswerIndex:= AnswerIndex + 1;
            END IF;
            CorrectedIndex:= CorrectedIndex + 1;
         END LOOP;

         Answer15Bit:= AnswerStr;
         RETURN Answer15Bit;
      END IF;

      --This if statement handles 11 Bit numbers
      IF Str'Length = ElevenBit THEN
         Answer11Bit:= Str;
         RETURN Answer11Bit;
      END IF;

      RETURN "000_0000_0000";
   END Extracted;

   ----------------------------------------------------------
   -- Purpose: Converts 11 bit number to decimal
   -- Parameters: String: a line of input in string form
   -- Precondition: Assumes the string is not empty
   -- Postcondition: Decimal version of 11bit Number
   ----------------------------------------------------------
   FUNCTION ConvertDecimal (
         Str : String)
     RETURN Integer IS

      FifteenBit : CONSTANT Natural := 18; --Size of 15 bit number with underscores
      ElevenBit  : CONSTANT Natural := 13; --Size of 11 bit number with underscores

      ExtractedData    : String (1 .. 13);                           --Holds 11 bit version of input
      Answer           : Integer                 := 0;               --Holds decimal version of the extracted value
      Count            : Integer                 := 0;               --Used to traverse backwards through NumArr
      Exponent         : Integer                 := 0;               --Represents the current exponent to multiply by for conversion
      ExtractedDataStr : String (1 .. ElevenBit) := (OTHERS => '0'); --11 bit array in string form
      NumArr           : Bit11Num                := (OTHERS => 0);   --11 bit array

   BEGIN

      ExtractedData:= Extracted(Str);
      ExtractedDataStr:= ExtractedData;

      FOR I IN 1..13 LOOP
         IF ExtractedDataStr(I) = '0' THEN
            NumArr(Count) := 0;
            Count:= Count + 1;
         ELSIF ExtractedDataStr(I) = '1' THEN
            NumArr(Count) := 1;
            Count:= Count + 1;
         END IF;
      END LOOP;

      FOR I IN REVERSE 0 .. 10 LOOP
         Answer:= Answer + (NumArr(I) * (2**(Exponent)));
         Exponent := Exponent + 1;
      END LOOP;

      RETURN Answer;

   END ConvertDecimal;

   ----------------------------------------------------------
   -- Purpose: Determines hamming for output
   -- Parameters: String: a line of input in string form
   -- Precondition: Assumes the string is not empty
   -- Postcondition: Returns hamming unbound string of
   --                hamming based on input
   ----------------------------------------------------------
   FUNCTION Hamming (
         Str : String)
     RETURN String IS

      FifteenBit       : CONSTANT Natural       := 18;           --Size of 15 bit number with underscores
      ElevenBit        : CONSTANT Natural       := 13;           --Size of 11 bit number with underscores
      Zero             : CONSTANT Unsigned_Byte := 2#0000_0000#; --Binary zero.
      One              : CONSTANT Unsigned_Byte := 2#0000_0001#; --Binary one.
      HammingStrLength : CONSTANT Integer       := 7;            --Fixed length of hamming String

      NumArr         : ParityBitArr;                                 --Array of parity bits
      Answer         : String (1 .. 7);                              --Returned hamming value
      Parity8Num     : Unsigned_Byte;                                --Bit representing parity 8 used for XOR function
      Parity4Num     : Unsigned_Byte;                                --Bit representing parity 4 used for XOR function
      Parity2Num     : Unsigned_Byte;                                --Bit representing parity 2 used for XOR function
      Parity1Num     : Unsigned_Byte;                                --Bit representing parity 1 used for XOR function
      Parity8        : Bit                      := 0;                --Bit representing parity 8
      Parity4        : Bit                      := 0;                --Bit representing parity 4
      Parity2        : Bit                      := 0;                --Bit representing parity 2
      Parity1        : Bit                      := 0;                --Bit representing parity 1
      Parity8Str     : String                   := " ";              --String version of parity bit 8
      Parity4Str     : String                   := " ";              --String version of parity bit 4
      Parity2Str     : String                   := " ";              --String version of parity bit 2
      Parity1Str     : String                   := " ";              --String version of parity bit 1
      Exponent       : Integer                  := 0;                --Used to keep track of exponent number
      HammingDecimal : Integer                  := 0;                --Decimal version of the parity bits
      Num            : Integer                  := 14;               --Index for traversing 15 bit number
      Num2           : Integer                  := 10;               --Index for traversing 11 bit number
      BitNumArr11    : ByteArr11                := (OTHERS => Zero); --11 bit array
      BitNumArr15    : ByteArr15                := (OTHERS => Zero); --15 bit array
      HammingBinary  : String (1 .. 4)          := (OTHERS => '0');  --array of parity bits in string form
      FixedStr15     : String (1 .. 15)         := (OTHERS => '0');  --Holds 15 bit number String without underscores
      FixedStr11     : String (1 .. 11)         := (OTHERS => '0');  --Holds 11 bit number String without underscores
      FinalStr11     : String (1 .. FifteenBit) := (OTHERS => '0');  --Holds 11 bit number String with underscores

   BEGIN

      IF Str'Length = FifteenBit THEN

         FixedStr15:= NoUnderScore(Str);

         FOR I IN FixedStr15'RANGE LOOP
            IF FixedStr15(I) = '0' THEN
               BitNumArr15(Num) := Zero;
               Num:= Num - 1;
            END IF;
            IF FixedStr15(I) = '1' THEN
               BitNumArr15(Num) := One;
               Num:= Num - 1;
            END IF;
         END LOOP;

         Parity8Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
            BitNumArr15(12) XOR BitNumArr15(11) XOR BitNumArr15(10) XOR
            BitNumArr15(9) XOR BitNumArr15(8) XOR BitNumArr15(7);

         --Handles parity 4
         Parity4Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
            BitNumArr15(12) XOR BitNumArr15(11) XOR BitNumArr15(6) XOR
            BitNumArr15(5) XOR BitNumArr15(4) XOR BitNumArr15(3);

         --Handles parity 2
         Parity2Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
            BitNumArr15(10) XOR BitNumArr15(9) XOR BitNumArr15(6) XOR
            BitNumArr15(5) XOR BitNumArr15(2) XOR BitNumArr15(1);

         --Handles parity 1
         Parity1Num:= BitNumArr15(14) XOR BitNumArr15(12) XOR
            BitNumArr15(10) XOR BitNumArr15(8) XOR BitNumArr15(6) XOR
            BitNumArr15(4) XOR BitNumArr15(2) XOR BitNumArr15(0);

         IF Parity8Num = 0 THEN
            Parity8Str:= "0";
            Parity8 := 0;
         ELSIF Parity8Num = 1 THEN
            Parity8Str:= "1";
            Parity8 := 1;
         END IF;

         IF Parity4Num = 0 THEN
            Parity4Str:= "0";
            Parity4 := 0;
         ELSIF Parity4Num = 1 THEN
            Parity4Str:= "1";
            Parity4 := 1;
         END IF;

         IF Parity2Num = 0 THEN
            Parity2Str:= "0";
            Parity2 := 0;
         ELSIF Parity2Num = 1 THEN
            Parity2Str:= "1";
            Parity2 := 1;
         END IF;

         IF Parity1Num = 0 THEN
            Parity1Str:= "0";
            Parity1 := 0;
         ELSIF Parity1Num = 1 THEN
            Parity1Str:= "1";
            Parity1 := 1;
         END IF;

         HammingBinary:= Parity8Str & Parity4Str & Parity2Str &
            Parity1Str;

         NumArr(1) := Parity8;
         NumArr(2) := Parity4;
         NumArr(3) := Parity2;
         NumArr(4) := Parity1;

         FOR I IN REVERSE 1 .. 4 LOOP
            HammingDecimal:= HammingDecimal + (NumArr(I) * (2**(Exponent)));
            Exponent := Exponent + 1;
         END LOOP;

         DECLARE
            FinalStr : String (1 .. 7);
         BEGIN
            IF HammingDecimal >= 10 THEN
               FinalStr:= HammingBinary & Integer'Image(HammingDecimal);
            END IF;
            IF HammingDecimal < 10 THEN
               FinalStr:= HammingBinary & " " & Integer'Image(
                  HammingDecimal);
            END IF;

            Answer:= FinalStr;
         END;

      END IF;

      --This if statement handles 11 Bit numbers
      IF Str'Length = ElevenBit THEN
         FixedStr11:= NoUnderScore(Str);

         FOR I IN FixedStr11'RANGE LOOP
            IF FixedStr11(I) = '0' THEN
               BitNumArr11(Num2) := Zero;
               Num2:= Num2 - 1;
            END IF;
            IF FixedStr11(I) = '1' THEN
               BitNumArr11(Num2) := One;
               Num2:= Num2 - 1;
            END IF;
         END LOOP;


         --Handles parity 8
         Parity8Num:= BitNumArr11(10) XOR BitNumArr11(9) XOR
            BitNumArr15(8) XOR BitNumArr11(7) XOR BitNumArr11(6) XOR
            BitNumArr15(5) XOR BitNumArr11(4);

         --Handles parity 4
         Parity4Num:= BitNumArr11(10) XOR BitNumArr11(9) XOR
            BitNumArr11(8) XOR BitNumArr11(7) XOR BitNumArr11(3) XOR
            BitNumArr11(2) XOR BitNumArr11(1);

         --Handles parity 2
         Parity2Num:= BitNumArr11(10) XOR BitNumArr11(9) XOR
            BitNumArr11(6) XOR BitNumArr11(5) XOR BitNumArr11(3) XOR
            BitNumArr11(2) XOR BitNumArr11(0);

         --Handles parity 1
         Parity1Num:= BitNumArr11(10) XOR BitNumArr11(8) XOR
            BitNumArr11(6) XOR BitNumArr11(4) XOR BitNumArr11(3) XOR
            BitNumArr11(1) XOR BitNumArr11(0);

         IF Parity8Num = 0 THEN
            Parity8Str:= "0";
            Parity8 := 0;
         ELSIF Parity8Num = 1 THEN
            Parity8Str:= "1";
            Parity8 := 1;
         END IF;

         IF Parity4Num = 0 THEN
            Parity4Str:= "0";
            Parity4 := 0;
         ELSIF Parity4Num = 1 THEN
            Parity4Str:= "1";
            Parity4 := 1;
         END IF;

         IF Parity2Num = 0 THEN
            Parity2Str:= "0";
            Parity2 := 0;
         ELSIF Parity2Num = 1 THEN
            Parity2Str:= "1";
            Parity2 := 1;
         END IF;

         IF Parity1Num = 0 THEN
            Parity1Str:= "0";
            Parity1 := 0;
         ELSIF Parity1Num = 1 THEN
            Parity1Str:= "1";
            Parity1 := 1;
         END IF;

         HammingBinary:= Parity8Str & Parity4Str & Parity2Str &
            Parity1Str;

         NumArr(1) := Parity8;
         NumArr(2) := Parity4;
         NumArr(3) := Parity2;
         NumArr(4) := Parity1;

         FOR I IN REVERSE 1 .. 4 LOOP
            HammingDecimal:= HammingDecimal + (NumArr(I) * (2**(Exponent)));
            Exponent := Exponent + 1;
         END LOOP;

         DECLARE
            FinalStr : String (1 .. 7);
         BEGIN
            IF HammingDecimal >= 10 THEN
               FinalStr:= HammingBinary & Integer'Image(HammingDecimal);
            END IF;
            IF HammingDecimal < 10 THEN
               FinalStr:= HammingBinary & " " & Integer'Image(HammingDecimal);
            END IF;

            Answer:= FinalStr;
         END;

      END IF;

      RETURN Answer;
   END Hamming;

   FUNCTION CheckHamming (
         Str : String)
     RETURN Integer IS

      FifteenBit       : CONSTANT Natural       := 18;           --Size of 15 bit number with underscores
      ElevenBit        : CONSTANT Natural       := 13;           --Size of 11 bit number with underscores
      Zero             : CONSTANT Unsigned_Byte := 2#0000_0000#; --Binary zero.
      One              : CONSTANT Unsigned_Byte := 2#0000_0001#; --Binary one.
      HammingStrLength : CONSTANT Integer       := 7;            --Fixed length of hamming String

      NumArr         : ParityBitArr;                                 --Array of parity bits                                 --Returned hamming value
      Parity8Num     : Unsigned_Byte;                                --Bit representing parity 8 used for XOR function
      Parity4Num     : Unsigned_Byte;                                --Bit representing parity 4 used for XOR function
      Parity2Num     : Unsigned_Byte;                                --Bit representing parity 2 used for XOR function
      Parity1Num     : Unsigned_Byte;                                --Bit representing parity 1 used for XOR function
      Parity8        : Bit                      := 0;                --Bit representing parity 8
      Parity4        : Bit                      := 0;                --Bit representing parity 4
      Parity2        : Bit                      := 0;                --Bit representing parity 2
      Parity1        : Bit                      := 0;                --Bit representing parity 1
      Parity8Str     : String                   := " ";              --String version of parity bit 8
      Parity4Str     : String                   := " ";              --String version of parity bit 4
      Parity2Str     : String                   := " ";              --String version of parity bit 2
      Parity1Str     : String                   := " ";              --String version of parity bit 1
      Exponent       : Integer                  := 0;                --Used to keep track of exponent number
      HammingDecimal : Integer                  := 0;                --Decimal version of the parity bits
      Num            : Integer                  := 14;               --Index for traversing 15 bit number
      Num2           : Integer                  := 10;               --Index for traversing 11 bit number
      BitNumArr11    : ByteArr11                := (OTHERS => Zero); --11 bit array
      BitNumArr15    : ByteArr15                := (OTHERS => Zero); --15 bit array
      HammingBinary  : String (1 .. 4)          := (OTHERS => '0');  --array of parity bits in string form
      FixedStr15     : String (1 .. 15)         := (OTHERS => '0');  --Holds 15 bit number String without underscores
      FixedStr11     : String (1 .. 11)         := (OTHERS => '0');  --Holds 11 bit number String without underscores
      FinalStr11     : String (1 .. FifteenBit) := (OTHERS => '0');  --Holds 11 bit number String with underscores

      Answer : Integer := 0;
   BEGIN

      FixedStr15:= NoUnderScore(Str);

      FOR I IN FixedStr15'RANGE LOOP
         IF FixedStr15(I) = '0' THEN
            BitNumArr15(Num) := Zero;
            Num:= Num - 1;
         END IF;
         IF FixedStr15(I) = '1' THEN
            BitNumArr15(Num) := One;
            Num:= Num - 1;
         END IF;
      END LOOP;

      Parity8Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
         BitNumArr15(12) XOR BitNumArr15(11) XOR BitNumArr15(10) XOR
         BitNumArr15(9) XOR BitNumArr15(8) XOR BitNumArr15(7);

      --Handles parity 4
      Parity4Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
         BitNumArr15(12) XOR BitNumArr15(11) XOR BitNumArr15(6) XOR
         BitNumArr15(5) XOR BitNumArr15(4) XOR BitNumArr15(3);

      --Handles parity 2
      Parity2Num:= BitNumArr15(14) XOR BitNumArr15(13) XOR
         BitNumArr15(10) XOR BitNumArr15(9) XOR BitNumArr15(6) XOR
         BitNumArr15(5) XOR BitNumArr15(2) XOR BitNumArr15(1);

      --Handles parity 1
      Parity1Num:= BitNumArr15(14) XOR BitNumArr15(12) XOR
         BitNumArr15(10) XOR BitNumArr15(8) XOR BitNumArr15(6) XOR
         BitNumArr15(4) XOR BitNumArr15(2) XOR BitNumArr15(0);

      IF Parity8Num = 0 THEN
         Parity8Str:= "0";
         Parity8 := 0;
      ELSIF Parity8Num = 1 THEN
         Parity8Str:= "1";
         Parity8 := 1;
      END IF;

      IF Parity4Num = 0 THEN
         Parity4Str:= "0";
         Parity4 := 0;
      ELSIF Parity4Num = 1 THEN
         Parity4Str:= "1";
         Parity4 := 1;
      END IF;

      IF Parity2Num = 0 THEN
         Parity2Str:= "0";
         Parity2 := 0;
      ELSIF Parity2Num = 1 THEN
         Parity2Str:= "1";
         Parity2 := 1;
      END IF;

      IF Parity1Num = 0 THEN
         Parity1Str:= "0";
         Parity1 := 0;
      ELSIF Parity1Num = 1 THEN
         Parity1Str:= "1";
         Parity1 := 1;
      END IF;

      HammingBinary:= Parity8Str & Parity4Str & Parity2Str &
         Parity1Str;

      NumArr(1) := Parity8;
      NumArr(2) := Parity4;
      NumArr(3) := Parity2;
      NumArr(4) := Parity1;

      FOR I IN REVERSE 1 .. 4 LOOP
         HammingDecimal:= HammingDecimal + (NumArr(I) * (2**(Exponent)));
         Exponent := Exponent + 1;
      END LOOP;
      RETURN Answer;
   END CheckHamming;
   ----------------------------------------------------------
   -- Purpose: Sort the the data based off the decimal value
   --          of extracted data.
   -- Parameters: outPut: array of solved input
   --             Integer: how many lines are in the file
   -- Precondition: assumes data and size have been
   --               initialized and are not blank.
   -- Postcondition: Prints output
   ----------------------------------------------------------
   PROCEDURE SortPrint (
         Item : CorrectedDataArr;
         Size : Integer) IS

      --Represents the first column of output
      TYPE InputArr IS ARRAY (0 .. Size) OF String (1 .. 18);

      --Represents the second column of output
      TYPE HammingArr IS ARRAY (0 .. Size) OF String (1 .. 7);

      --Represents the third column of output
      TYPE CorrectedArr IS ARRAY (0 .. Size) OF String (1 .. 18);

      --Represents the Fourth column of output
      TYPE ExtractedArr IS ARRAY (0 .. Size) OF String (1 .. 13);

      --Represents the Fifth column of output
      TYPE DeciArr IS ARRAY (0 .. Size) OF Integer;

      Column1 : InputArr;     --Stores the first column for output
      Column2 : HammingArr;   --Stores the second column for output
      Column3 : CorrectedArr; --Stores the third column for output
      Column4 : ExtractedArr; --Stores the fourth column for output
      Column5 : DeciArr;      --Stores the fifth column for output

      --Turns eleven bit numbers blank
      Blank : String := ("                  ");

      First  : Natural          := 0;    --First item in the variant record
      Last   : Natural          := Size; --Last item in the variant record that has data
      Value1 : String (1 .. 18);         --Holds value of input data
      Value2 : String (1 .. 7);          --Holds value of hamming data
      Value3 : String (1 .. 18);         --Holds value of corrected data
      Value4 : String (1 .. 13);         --Holds value of extrated data
      Value5 : Integer;                  --Holds value of decimal value data
      J      : Integer;                  --Index used for sorting

   BEGIN

      FOR I IN 0 .. Size LOOP
         CASE Item(I).Bit_Type IS
            WHEN Bit15 =>
               Column1(I) := Item(I).Original_15Bit;
               Column2(I) := Item(I).BitNum_15Bit;
               Column3(I) := Item(I).Corrected_15Bit;
               Column4(I) := Item(I).Extracted_15Bit;
               Column5(I) := Item(I).Deci_15Bit;
            WHEN Bit11 =>
               Column1(I) := Blank;
               Column2(I) := Item(I).BitNum_11Bit;
               Column3(I) := Item(I).Corrected_11Bit;
               Column4(I) := Item(I).Extracted_11Bit;
               Column5(I) := Item(I).Deci_11Bit;
         END CASE;
      END LOOP;

      Put(
         "Possible Error       Hamming     No Errors                 No Hamming");
      New_Line;

      --This for loop Sorts Data
      FOR I IN (First + 1)..Last LOOP
         Value1 := Column1(I);
         Value2 := Column2(I);
         Value3 := Column3(I);
         Value4 := Column4(I);
         Value5 := Column5(I);
         J := I - 1;

         WHILE J IN Column5'RANGE AND THEN Column5(J) > Value5 LOOP

            Column1(J + 1) := Column1(J);
            Column2(J + 1) := Column2(J);
            Column3(J + 1) := Column3(J);
            Column4(J + 1) := Column4(J);
            Column5(J + 1) := Column5(J);
            J := J - 1;

         END LOOP;

         WHILE J IN Column5'RANGE AND THEN Column5(J) = Value5 LOOP

            IF Column1(J) = Blank THEN
               Column1(J + 1) := Column1(J);
               Column2(J + 1) := Column2(J);
               Column3(J + 1) := Column3(J);
               Column4(J + 1) := Column4(J);
               Column5(J + 1) := Column5(J);
               J := J - 1;
            ELSE
               Column1(J + 1) := Column1(J);
               Column2(J + 1) := Column2(J);
               Column3(J + 1) := Column3(J);
               Column4(J + 1) := Column4(J);
               Column5(J + 1) := Column5(J);
               J := J - 1;
            END IF;

         END LOOP;

         Column1(J + 1) := Value1;
         Column2(J + 1) := Value2;
         Column3(J + 1) := Value3;
         Column4(J + 1) := Value4;
         Column5(J + 1) := Value5;

      END LOOP;

      --Prints Data
      FOR I IN 0 .. Size LOOP
         Put(Column1(I));
         Put(" : ");
         Put(Column2(I));
         Put(" : ");
         Put(Column3(I));
         Put(" : ");
         Put(Column4(I));
         Put(" : ");
         Put(Column5(I), 4);
         New_Line;
      END LOOP;

   END SortPrint;

   ----------------------------------------------------------
   -- Purpose: Reads in, stores, and corrects the input data.
   -- Parameters: None.
   -- Precondition: input Data is correctly formated
   -- Postcondition: Prints corrected data
   ----------------------------------------------------------
   PROCEDURE Solve IS

      FifteenBit : CONSTANT Natural := 18; --Size of 15 bit number with underscores
      ElevenBit  : CONSTANT Natural := 13; --Size of 11 bit number with underscores

      Data         : CorrectedDataArr;      --Blank array for storing data from file
      I            : Integer          := 0; --Index for reading data file
      DataFileSize : Integer          := 0; --Number of lines inside file

   BEGIN
      WHILE NOT End_Of_File LOOP

         Read_Block: DECLARE

            DataStr :          String  := Get_Line;       -- String s is dynamically allocated
            Len     : CONSTANT Natural := DataStr'Length; --Length of dataStr

         BEGIN

            IF Len = FifteenBit THEN
               Data(I):= (Bit15, DataStr, Hamming(DataStr), NoErrors(DataStr),

                  Extracted(DataStr), ConvertDecimal(DataStr));
            END IF;
            IF Len = ElevenBit THEN
               Data(I):= (Bit11, DataStr, Hamming(DataStr), NoErrors(DataStr),
                  Extracted(DataStr), ConvertDecimal(DataStr));
            END IF;

            I:= I + 1;
            DataFileSize:= DataFileSize + 1;

         END Read_Block;

      END LOOP;

      DataFileSize:= DataFileSize - 1;

      SortPrint(Data, DataFileSize); --Sorts all data and prints it

   END Solve;

BEGIN

   Solve;

END Ham2;