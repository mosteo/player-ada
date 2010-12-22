

--  Position proxy interface
with Player.Client;
with Player.Interfaces;
with Player.Types;


package Player.Simulation is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_position_t *

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   function Get_Pose2d (This : in Object; Id : in String) return Pose;

private

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_simulation_destroy");

   pragma Inline (Get_Pose2d);

end Player.Simulation;
