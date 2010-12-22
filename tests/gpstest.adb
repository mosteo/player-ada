with Player;
with Player.Client;
with Player.Debug; use Player.Debug;
with Player.Gps;

with Text_IO; use Text_IO;

procedure gpstest is
   use Player;

   Conn    : Client.Connection_Type;
   G       : Gps.Object;
begin
   Client.Create (Conn, "localhost", 6665);
   Client.Connect (Conn);
   Client.Datamode (Conn, Client.Datamode_Pull);

   Put_Line ("Connected.");

   Gps.Create (G, Conn);
   Gps.Subscribe (G, Player.Open_Mode);

   Put_Line ("Suscribed.");

   while True loop
      Client.Read (Conn); -- Block an read sent data
      Put_Line ("------------------------------------------------------");

      Put_Line ("Coords:     " & To_String (Gps.Get_Coords (G)));
      Put_Line ("Location:   " & To_String (Gps.Get_Location (G)));
      Put_Line ("Fix:        " & Gps.Get_Quality (G)'Img);
      Put_Line ("Satellites: " & Gps.Get_Satellites (G)'Img);
      Put_Line ("Elapsed:    " & Gps.Get_Seconds (G)'Img);
      delay 1.0;
   end loop;
end gpstest;
