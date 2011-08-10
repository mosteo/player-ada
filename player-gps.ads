--  GPS proxy interface

with Player.Client;
with Player.Interfaces;
with Player.Types;

package Player.Gps is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_laser_t *

   type Fix_Quality is (Invalid, Gps, Dgps);
   --  No fix, satellite fix, satellite+differential correction

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

private

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_gps_destroy");

end Player.Gps;
