with Ada.Numerics.Generic_Elementary_Functions;
with Interfaces.C;
with Text_Io; use Text_Io;
with Player;

procedure test_trigo is
   type Double is new Player.Double;
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Double);
   use Math;

   D : Double := 0.0;
begin
   while D < 6.28 loop
      Put_Line (D'Img & "   " & Double'Image (Sin (D)));
      D := D + 0.1;
   end loop;
end test_trigo;
