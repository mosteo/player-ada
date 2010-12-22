

--  Root package for the binding to the C library libplayerc.

--  As a general rule, names of entities/functions are keep as closer as the
--  C ones to keep consistency, even if that means they're not totally Adaish.

--  All functions returning an error code are replaced by procedures which may
--  raise Player_Error.

--  Where possible, creation and destruction of C structs has been replace by
--  Controlled types. There seems to be some problem with creating the same
--  object multiple times, so in general avoid it.

with Interfaces.C;

package Player is

   pragma Pure;

   package I renames Interfaces;

   --  The linking of playerc is in player-interfaces.ads
   --  This allows "with" this root file without causing the linking.

   --  Some definitions of general use

   type C_Float is new Interfaces.C.C_Float;
   subtype Player_Float is C_Float;
   type Double is new Interfaces.C.double;
   type Double_Array is array (Positive range <>) of Double;
   type Double_Matrix is array (Positive range <>, Positive range <>) of Double;

   type Point_2d is record
      X, Y : aliased Double;
   end record;

   subtype Pose is Double_Array (1 .. 3);
   subtype Velo is Double_Array (1 .. 3);
   subtype Covariance is Double_Matrix (1 .. 3, 1 .. 3);

   type Pose_Array is array (Positive range <>) of Pose;

   subtype HPose is Double_Array (1 .. 4);
   --  Homogeneous representation, (x, y, a, 1)

   subtype Transformation is Double_Matrix (1 .. 4, 1 .. 4);
   --  Extended to include the pose in the transformation.

   --  Some record structures depend on the fact that Double is C.double,
   --  because doubles are used all over the place in Player.

   --  Device access modes:
   type Access_Modes is new Integer;
   function Open_Mode  return Access_Modes;
   function Close_Mode return Access_Modes;
   function Error_Mode return Access_Modes;

   function "-" (D : in Double_Array) return Double_Array;
   --  Unary negation

   --  Message types
   Msgtype_Data      : constant := 1;
   Msgtype_Cmd       : constant := 2;
   Msgtype_Req       : constant := 3;
   Msgtype_Resp_Ack  : constant := 4;
   Msgtype_Synch     : constant := 5;
   Msgtype_Resp_Nack : constant := 6;

private

   pragma Convention (C, Point_2d);

   pragma Convention (C, Double_Array);
   pragma Convention (C, Double_Matrix);
   pragma Convention (C, Pose_Array);

   pragma Import (C, Open_Mode,  "playerc_open_mode");
   pragma Import (C, Close_Mode, "playerc_close_mode");
   pragma Import (C, Error_Mode, "playerc_error_mode");

   pragma Convention (C, Access_Modes);

end Player;
