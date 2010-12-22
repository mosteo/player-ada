 --  Laser proxy interface

with Player.Client;
with Player.Interfaces;
with Player.Types;

with Interfaces; use  Interfaces;

package Player.Laser is

--  For now, this hasn't been optimized for speed
--  Each retrieval of a scan point/range/etc is a static call to the C side.
--  If this proves too inefficient, Ada-side caching should be added, when the
--  scan timestamp changes.

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_laser_t *

   type Scan is record
      Rang      : Double;
      Bearing   : Double;
      X, Y      : Double;
      Intensity : Natural; -- 0 .. 3
   end record;

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   procedure Set_Config
     (This       : in out Object;
      Min_Angle,
      Max_Angle  : in Double;  -- Radians
      Resolution : in Double;  -- 25, 50, 100 cents of degree (?)
      Range_Res  : in Double;  -- 1, 10, 100 mm.
      Intensity  : in Boolean;
      Frequency  : in Double); -- Depends on hardware, for Sick is 50, 100Hz

   procedure Get_Config
     (This       : in Object;
      Min_Angle,
      Max_Angle  : out Double;
      Resolution,
      Range_Res  : out Double;
      Intensity  : out Boolean;
      Frequency  : out Double);

   function Get_Pose (This : in Object) return Pose;
   --  Of the laser on the robot center.

   function Get_Size (This : in Object) return Double_Array;
   --  Returns width and height.

   function Get_Scan_Count (This : in Object) return Natural;

   function Get_Scan_Start (This : in Object) return Double;
   --  Starting bearing.

   function Get_Scan_Res (This : in Object) return Double;
   --  Angular resolution (radians).

   function Get_Range_Res (This : in Object) return Double;
   --  Range resolution, whatever it is

   function Get_Max_Range (This : in Object) return Double;

   function Get_Scan (This : in Object; Idx : in Positive) return Scan;

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
--
--     function Get_Intensity (This : in Object; Scan : in Positive)
--                             return Natural;
--     --  0 .. 3. Intensity must be enabled.

   function Get_Scan_Id (This : in Object) return Integer;
   --  Serial number that can be used to detect a new laser reading.

   function Get_Robot_Pose (This : in Object) return Pose;
   --  Pose when the reading was taken

private

   pragma Inline
     (Get_Pose, Get_Size,
      Get_Scan_Count, Get_Scan_Start, Get_Scan_Res, Get_Range_Res,
--        Get_Range, Get_Bearing, Get_Point, Get_Intensity,
      Get_Scan_Id,
      Get_Robot_Pose);

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_laser_destroy");

   function Update_Geom (This : in Types.Handle) return C.int;
   pragma Import (C, Update_Geom, "playerc_laser_get_geom");

   type Point_2d_T is record
      Px, Py : C.C_Float;
   end record;
   pragma Convention (C, Point_2d_T);

   type Point_2d_Array is array (Integer range <>) of Point_2d_T;

end Player.Laser;
