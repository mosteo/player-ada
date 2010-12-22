with Player;
with Player.Client;
with Player.Position2d;

with Ada.Exceptions; use Ada.Exceptions;
with Text_IO; use Text_IO;

procedure Postest is
   use Player;

   Conn    : Client.Connection_Type;
   Pos     : Position2d.Object;
begin
   Client.Create (Conn, "localhost", 6665);
   Client.Connect (Conn);
   Client.Datamode (Conn, Client.Datamode_Pull);

   Put_Line ("Connected.");

   Position2d.Create (Pos, Conn, 0);
   Position2d.Subscribe (Pos, Player.Open_Mode);
   Put_Line ("Subscribed.");
   Position2d.Enable (Pos, False);
   Position2d.Enable (Pos);
   Put_Line ("Enabled.");
   Put_Line ("Moving.");

   loop
      Client.Read (Conn); -- Block an read sent data
      Position2d.Set_Cmd_Vel (Pos, 0.1, 0.0, 0.0);
   end loop;
exception
   when E : others =>
      Put_Line (Exception_Information (E));
end Postest;
