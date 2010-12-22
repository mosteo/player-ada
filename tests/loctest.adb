with Player;
with Player.Client;
with Player.Debug;
with Player.Localize;
with Player.Multi_Client;
with Player.Position2d;

with Ada.Calendar; use Ada.Calendar;
with Text_IO; use Text_IO;

procedure Loctest is
   use Player;

   Manager : Multi_Client.Object;
   Conn    : Client.Connection_Type;
   Pos     : Position2d.Object;
   Loc     : Localize.Object;
   Start   : constant Time := Clock;
begin
   Client.Create (Conn, Manager, "localhost", 6665);
   Client.Connect (Conn);

   Put_Line ("Connected.");

   Position2d.Create (Pos, Conn);
   Position2d.Subscribe (Pos, Player.Open_Mode);
   Localize.Create (Loc, Conn);
   Localize.Subscribe (Loc, Player.Open_Mode);

   while Clock - Start < 10.0 or True loop
      Multi_Client.Read (Manager); -- Block an read sent data
      declare
         X, Y, A : Player.Double;
         Hyps    : constant Localize.Hypothesis_Array :=
                     Localize.Get_Hypothesis (Loc);
      begin
         Position2d.Get_Pose (Pos, X, Y, A);
         Put_Line ("Elapsed:" & Duration'Image (Clock - Start) &
                   "; X =" & Debug.To_String (X) &
                   "; Y =" & Debug.To_String (Y) &
                   "; A =" & Debug.To_String (A));
         if Hyps'Length > 0 then
            Put_Line ("Best Hypothesis" &
                      ":      X =" & Debug.To_String (Hyps (1).Mean (1)) &
                      "; Y =" & Debug.To_String (Hyps (1).Mean (2)) &
                      "; A =" & Debug.To_String (Hyps (1).Mean (3)) &
                      "; W =" & Debug.To_String (Hyps (1).Weight));
         else
            Put_Line ("Localization lost.");
         end if;
      end;
   end loop;
end Loctest;
