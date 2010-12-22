with Ada.Containers.Vectors,
     Interfaces.C;

--  Auxiliary types for the binding

package Player.Types is

   pragma Preelaborate;

   type Handle is private;
   --  A handle is our way to represent the C pointers.

   type int_array is array (Integer range <>) of Interfaces.C.int;

   function Is_Null (This : in Handle) return Boolean;

   procedure Set_Null (This : in out Handle);

   type Uint8 is mod 2 ** 8;

   subtype Player_Float is Player.Player_Float;

   type Point_2d_Array is array (Positive range <>) of aliased Point_2d;
   pragma Convention (C, Point_2d_Array);

   package Point_2d_Vectors is new Ada.Containers.Vectors (Positive, Point_2d);
   subtype Point_2d_Vector is Point_2d_Vectors.Vector;

   function To_Vector (P : Point_2d_Array) return Point_2d_Vector;

   type Player_Color_Type is record -- player_color_t
      Alpha : Uint8;
      Red   : Uint8;
      Green : Uint8;
      Blue  : Uint8;
   end record;
   pragma Convention (C, Player_Color_Type);

private

   type Handle is access Interfaces.C.int;
   pragma Convention (C, Handle);

   pragma Convention (C, int_array);

   pragma Inline (Is_Null, Set_Null);

end Player.Types;
