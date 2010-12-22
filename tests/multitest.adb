with Player;
with Player.Client;
with Player.Debug;
with Player.Multi_Client;
with Player.Position2d;

with Ada.Calendar; use Ada.Calendar;
with Text_IO; use Text_IO;

procedure Multitest is
   use Player;

   Manager : Multi_Client.Object;
   Conn    : Client.Connection_Type;
   Conn2   : Client.Connection_Type;
   Pos     : Position2d.Object;
   Pos2    : Position2d.Object;
   Start   : constant Time := Clock;
begin
   Client.Create (Conn, Manager, "localhost", 6665);
   Client.Create (Conn2, Manager, "localhost", 6666);
   Client.Connect (Conn);
   Client.Connect (Conn2);

   Put_Line ("Connected.");

   Position2d.Create (Pos, Conn);
   Position2d.Create (Pos2, Conn2);
   Position2d.Subscribe (Pos,  Player.Open_Mode);
   Position2d.Subscribe (Pos2, Player.Open_Mode);

   Position2d.Set_Cmd_Vel (Pos, 0.0, 0.0, 0.2);
   Position2d.Set_Cmd_Vel (Pos2, 0.0, 0.0, -0.2);
   while Clock - Start < 10.0 loop
      Multi_Client.Read (Manager); -- Block an read sent data
      declare
         X, Y, A : Player.Double;
      begin
         Position2d.Get_Pose (Pos, X, Y, A);
         Put_Line ("Elapsed:" & Duration'Image (Clock - Start) &
                   "; X =" & Debug.To_String (X) &
                   "; Y =" & Debug.To_String (Y) &
                   "; A =" & Debug.To_String (A));
      end;
   end loop;
end Multitest;
