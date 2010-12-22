with Player;
with Player.Client;
with Player.Multi_Client;
with Player.Position2d;

--  with Ada.Calendar; use Ada.Calendar;
with Ada.Exceptions; use Ada.Exceptions;
with Text_IO; use Text_IO;

procedure Veltest is
   use Player;

   Manager : Multi_Client.Object;
   Conn    : Client.Connection_Type;
   Pos     : Position2d.Object;
begin
   Client.Create (Conn, Manager, "localhost", 6665);
   Client.Connect (Conn);

   Put_Line ("Connected.");

   Position2d.Create (Pos, Conn, 1);
   Position2d.Subscribe (Pos, Player.Open_Mode);

   Position2d.Set_Cmd_Vel (Pos, 0.2, 0.0, 0.0);

   loop
      Multi_Client.Read (Manager); -- Block an read sent data
   end loop;
exception
   when E : others =>
      Put_Line (Exception_Information (E));
end Veltest;
