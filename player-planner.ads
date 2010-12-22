

--  Planner proxy interface

with Player.Client;
with Player.Interfaces;
with Player.Types;


package Player.Planner is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_planner_t *

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   procedure Enable       (This : in out Object; Enabled : in Boolean := True);

--     function Get_Path_Valid (This : in Object) return Boolean;
--
--     function Get_Path_Done (This : in Object) return Boolean;
--
--     function Get_Current_Pose (This : in Object) return Pose;
--
--     function Get_Goal_Location (This : in Object) return Pose;
--
--     function Get_Current_Waypoint_Location (This : in Object) return Pose;
--
--     function Get_Current_Waypoint_Index (This : in Object) return Natural;
--
--     function Get_Waypoint_Count (This : in Object) return Natural;
--
--     function Get_Waypoints (This : in Object) return Pose_Array;

   procedure Set_Cmd_Pose
     (This    : in Object;
      X, Y, A : in Double);

private

   use Interfaces;

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_planner_destroy");

   function Get_Planner_Max_Waypoints return I.C.int;
   pragma Import (C, Get_Planner_Max_Waypoints);

   procedure Update_Waypoints (This : in Types.Handle);
   pragma Import (C, Update_Waypoints, "playerc_planner_get_waypoints");

   Enabling : constant array (Boolean) of I.C.Int :=
                (False => 0, True => 1);

end Player.Planner;
