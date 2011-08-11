--  Sonar proxy interface

with Player.Client;
with Player.Interfaces;
with Player.Types;

package Player.Sonar is

--  For now, this hasn't been optimized for speed
--  Each retrieval of a scan point/range/etc is a static call to the C side.

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_sonar_t *

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   function Get_Pose_Count (This : in Object) return Natural;

   function Get_Pose (This : in Object; Idx : in Positive) return Pose_3d;
   --  Of the Idx-th sonar on the robot center.

   function Get_Scan_Count (This : in Object) return Natural;

   function Get_Scan (This : in Object; Idx : in Positive) return Double;

--     function Get_Range (This : in Object; Scan : in Positive) return Double;
--     --  Raw indexed data.
--
--     function Get_Bearing (This : in Object; Scan : in Positive) return Double;
--     --  Bearing indexed data.
--
--     function Get_Point (This : in Object; Scan : in Positive)
--                         return Double_Array;
--     --  X, Y in robot reference.
--
--     function Get_Point_Pose (This : in Object; Scan : in Positive) return Pose;
--     --  X, Y and A in robot reference.

   procedure Update_Geom (This : in out Object);

private

   pragma Inline
     (Get_Pose, Get_Pose_Count,
--        Get_Range, Get_Bearing, Get_Point, Get_Intensity,
      Get_Scan_Count, Get_Scan);

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_sonar_destroy");

end Player.Sonar;
