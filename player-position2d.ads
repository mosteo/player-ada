--  Position proxy interface
with Player.Client;
with Player.Interfaces;
with Player.Types;


package Player.Position2d is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_position2d_t *

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   procedure Enable       (This : in out Object; Enabled : in Boolean := True);

   procedure Get_Geom     (This : in Object; X, Y, A : out Double);

   procedure Get_Size     (This : in Object; W, H : out Double);

   procedure Get_Pose     (This : in Object; X, Y, A : out Double);

   function  Get_Pose     (This : in Object) return Pose;

   procedure Get_Velocity (This : in Object; X, Y, A : out Double);

   function  Get_Velocity (This : in Object) return Velo;

   function Get_Stalled  (This : in Object) return Boolean;

   procedure Set_Pose (This    : in Object;
                       X, Y, A : in Double);

   procedure Set_Pose (This : in Object;
                       P    : in Pose);
   --  Reset odometry offset

   procedure Set_Cmd_Vel
     (This    : in Object;
      X, Y, A : in Double;
      Enable  : in Boolean := True);

   procedure Set_Cmd_Vel
     (This    : in Object;
      P       : in Pose;
      Enable  : in Boolean := True);

   procedure Set_Cmd_Pose
     (This    : in Object;
      X, Y, A : in Double;
      Enable  : in Boolean := True);

   procedure Set_Cmd_Pose
     (This    : in Object;
      P       : in Pose;
      Enable  : in Boolean := True);

private

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_position2d_destroy");

   Enabling : constant array (Boolean) of Standard.Interfaces.C.int :=
                (False => 0, True => 1);

   pragma Inline (Get_Geom);
   pragma Inline (Get_Size);
   pragma Inline (Get_Pose);
   pragma Inline (Get_Velocity);
   pragma Inline (Get_Stalled);

end Player.Position2d;
