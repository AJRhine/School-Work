WITH Ada.Text_IO;
USE Ada.Text_IO;
WITH Ada.Float_Text_IO;
USE Ada.Float_Text_IO;
WITH Ada.Integer_Text_IO;
USE Ada.Integer_Text_IO;
WITH Ada.Command_Line;

PROCEDURE Hiring IS

   ----------------------------------------------------------
   -- Purpose:
   -- Parameters:
   -- Precondition:
   -- Postcondition:
   ----------------------------------------------------------
   FUNCTION Algorithm (
         N : Natural)
     RETURN Float IS
      Num             :          Float;
      Ans             :          Float;
      Eulers_Constant : CONSTANT Float := 2.718_2818_28;
   BEGIN
      Num:= Float(N);
      Ans:= Num / Eulers_Constant;
      Ans:= Float'Floor(Ans);
      RETURN Ans;
   END Algorithm;

   ----------------------------------------------------------
   -- Purpose: Checks if the algorithm picked the best candiate.
   -- Parameters: Best, Outcome: Values
   -- Precondition:
   -- Postcondition: Returns boolean representation of
   ----------------------------------------------------------
   FUNCTION Checker (
         Best,
         Outcome : Integer)
     RETURN Boolean IS
      Ans : Boolean := False;
   BEGIN
      IF Best = Outcome THEN
         Ans:= True;
      END IF;
      RETURN Ans;
   END Checker;

   SUBTYPE Candidate_Number IS Integer RANGE 0 .. 999;
   --Represents the number of candidates in the dataset.

   Multiplier : CONSTANT Float := 100.0; --Used to get the correct percent correct.

   I                 : Integer;                   --Represents integer in dataset.
   Candidate_Num     : Candidate_Number := 0;     --Represents current candidate in dataset.
   Candidate_Counter : Integer          := 0;     --Represents number of candidates in dataset.
   Reject_Num        : Float;                     --Represents number of rejects in dataset.
   Best_In_R         : Integer;                   --Represents best reject candidate in dataset.
   Selected          : Integer          := 0;     --Represents the selected candidate based of algorithm.
   Correct           : Integer          := 0;     --Represents the amount of times the algorithm was correct.
   Not_Correct       : Integer          := 0;     --Represents the amount of times the algorithm was not correct.
   Answer            : Boolean          := False; --Boolean representation of whether the algorithm worked or not.
   Percent_Correct   : Float;                     --Represents how accurate the algorithm was when applied to the dataset.

BEGIN
   --This if Handles Verbose Option
   IF Ada.Command_Line.Argument_Count = 0 THEN
      WHILE NOT End_Of_File LOOP
         Get(I);

         --Finds the candidate with the highest rating in list of reject candidates.
         IF Candidate_Counter = 1 THEN
            Best_In_R := I;
         ELSIF Candidate_Counter <= Integer(Reject_Num) THEN
            IF I > Best_In_R THEN
               Best_In_R := I;
            END IF;
         END IF;

         --Finds the selected candidate based off the algorithm.
         IF Candidate_Counter > Integer(Reject_Num) AND Selected <
               Best_In_R THEN
            IF I > Best_In_R THEN
               Selected := I;
            ELSIF Candidate_Num = Candidate_Counter AND Selected <
                  Best_In_R THEN
               Selected:= I;
            END IF;
         END IF;

         IF Candidate_Num = 0 THEN
            Candidate_Num := Candidate_Number(I);

         ELSIF Candidate_Num = Candidate_Number(Candidate_Counter) THEN

            Reject_Num := Algorithm(Candidate_Num);
            --Finds the number of candidates to reject based of the algorithm.

            Answer:= Checker(Candidate_Num, Selected);

            IF Answer = True THEN
               Correct:= Correct + 1;
            ELSIF Answer = False THEN
               Not_Correct := Not_Correct + 1;
            END IF;

         ELSIF Candidate_Counter > Integer(Candidate_Num) THEN
            Candidate_Num := Candidate_Number(I);
            Candidate_Counter := 0;
            Selected:= 0;
         END IF;
         Candidate_Counter:= Candidate_Counter + 1;

      END LOOP;

      New_Line;
      Put_Line(
         "          Correct    Not Correct  Total    Percent Correct");
      Put(Correct, 16);
      Put(Not_Correct, 13);
      Put(Not_Correct + Correct, 10);
      Percent_Correct:= (Float(Correct) / Float(Not_Correct + Correct));
      Percent_Correct:= Percent_Correct * Float(100);
      Put(Percent_Correct, Fore => 11, Aft => 1, Exp => 0);

      --This if handles Verbose Option
   ELSIF Ada.Command_Line.Argument(1) = "-v" THEN
      Put_Line("          n    r   Best in r  Selected"
         & "  Best Overall  Correct   Not Correct");
      WHILE NOT End_Of_File LOOP
         Get(I);

         --Finds out the greatest candidate rating in list of rejects.
         IF Candidate_Counter = 1 THEN
            Best_In_R := I;
         ELSIF Candidate_Counter <= Integer(Reject_Num) THEN
            IF I > Best_In_R THEN
               Best_In_R := I;
            END IF;
         END IF;

         IF Candidate_Counter > Integer(Reject_Num) AND Selected <
               Best_In_R THEN
            IF I > Best_In_R THEN
               Selected := I;
            ELSIF Candidate_Num = Candidate_Counter AND Selected <
                  Best_In_R THEN
               Selected:= I;
            END IF;
         END IF;

         IF Candidate_Num = 0 THEN
            Candidate_Num := Candidate_Number(I);

            --This if prints final output for dataset if verbose data set is verbose.
         ELSIF Candidate_Num = Candidate_Number(Candidate_Counter) THEN
            Put(Candidate_Num);
            Reject_Num := Algorithm(Candidate_Num);
            --Finds the number of candidates to reject based of the algorithm.
            Put(Integer(Reject_Num), 5);
            Put(Best_In_R, 9);
            Put(Selected, 10);
            Put(Candidate_Num, 12);
            Answer:= Checker(Candidate_Num, Selected);

            IF Answer = True THEN
               Correct:= Correct + 1;
            ELSIF Answer = False THEN
               Not_Correct := Not_Correct + 1;
            END IF;
            Put(Correct, 13);
            Put(Not_Correct, 12);
            New_Line;

            --Handles the candidate counter and resets counter once end of candidate list is reached.
         ELSIF Candidate_Counter > Integer(Candidate_Num) THEN
            Candidate_Num := Candidate_Number(I);
            Candidate_Counter := 0;
            Selected:= 0;
         END IF;
         Candidate_Counter:= Candidate_Counter + 1;

      END LOOP;
      New_Line;
      Put_Line(
         "          Correct    Not Correct  Total    Percent Correct");
      Put(Correct, 16);
      Put(Not_Correct, 13);
      Put(Not_Correct + Correct, 10);
      Percent_Correct:= (Float(Correct) / Float(Not_Correct + Correct));
      Percent_Correct:= Percent_Correct * Float(100);
      Put(Percent_Correct, Fore => 11, Aft => 1, Exp => 0);

   END IF;

END Hiring;
