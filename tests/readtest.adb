with Player;
with Player.Client;
with Player.Debug;
with Player.Position2d;

with Ada.Calendar; use Ada.Calendar;
with Text_IO; use Text_IO;

procedure Readtest is
   use Player;

   Conn  : Client.Connection_Type;
   Pos   : Position2d.Object;
   Start : constant Time := Clock;
begin
   Client.Create (Conn, "localhost", 6665);
   Client.Connect (Conn);

   Put_Line ("Connected.");

   Position2d.Create (Pos, Conn);
   Position2d.Subscribe (Pos, Player.Open_Mode);

   loop
      while Client.Peek (Conn) loop
         Client.Read (Conn); -- Block an read sent data
      end loop;
      declare
         X, Y, A    : Player.Double;
         Vx, Vy, Va : Player.Double;
      begin
         Position2d.Get_Pose     (Pos, X, Y, A);
         Position2d.Get_Velocity (Pos, Vx, Vy, Va);
         Put_Line ("Elapsed:" & Duration'Image (Clock - Start) &
                   "; X =" & Debug.To_String (X) &
                   "; Y =" & Debug.To_String (Y) &
                   "; A =" & Debug.To_String (A) &
                   "; Vx =" & Debug.To_String (Vx) &
                   "; Vy =" & Debug.To_String (Vy) &
                   "; Va =" & Debug.To_String (Va));
      end;
      delay 0.01;
   end loop;
end Readtest;
