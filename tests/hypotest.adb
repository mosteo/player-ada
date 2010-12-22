with Player;
with Player.Client;
with Player.Debug;
with Player.Localize;
with Player.Multi_Client;
with Player.Position2d;

with Ada.Calendar; use Ada.Calendar;
with Text_IO; use Text_IO;

procedure Hypotest is
   use Player;

   Manager : Multi_Client.Object;
   Conn    : Client.Connection_Type;
   Pos     : Position2d.Object;
   Loc     : Localize.Object;
   Start   : constant Time := Clock;
   Check   : Time          := Clock;
begin
   Client.Create (Conn, Manager, "localhost", 6665);
   Client.Connect (Conn);

   Put_Line ("Connected.");

   Position2d.Create (Pos, Conn);
   Position2d.Subscribe (Pos, Player.Open_Mode);
   Localize.Create (Loc, Conn);
   Localize.Subscribe (Loc, Player.Open_Mode);

   while True loop
      Multi_Client.Read (Manager); -- Block an read sent data
      declare
         X, Y, A : Player.Double;
         Hyps    : constant Localize.Hypothesis_Array :=
                     Localize.Get_Hypothesis (Loc);
      begin
         if Clock - Check > 1.0 then
            Check := Check + 1.0;
            Position2d.Get_Pose (Pos, X, Y, A);
            Put_Line ("Elapsed:" & Duration'Image (Clock - Start) &
                      "; X =" & Debug.To_String (X) &
                      "; Y =" & Debug.To_String (Y) &
                      "; A =" & Debug.To_String (A));

            for I in Hyps'Range loop
               Put_Line ("Hypothesis" & I'Img &
                         ":      X =" & Debug.To_String (Hyps (I).Mean (1)) &
                         "; Y =" & Debug.To_String (Hyps (I).Mean (2)) &
                         "; A =" & Debug.To_String (Hyps (I).Mean (3)) &
                         "; W =" & Debug.To_String (Hyps (I).Weight));
            end loop;
         end if;
      end;
   end loop;
end Hypotest;
