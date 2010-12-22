--  Graphics2d proxy interface
with Player.Client;
with Player.Interfaces;
with Player.Types;

package Player.Graphics2d is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_graphics2d_t *

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   procedure Clear (This : in out Object);

   procedure Set_Color (This  : in out Object;
                        Color : in     Types.Player_Color_Type);

   function Get_Color (This : Object) return Types.Player_Color_Type;

   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Array);

   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Vector);

   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Array);

   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Vector);

private

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_graphics2d_destroy");

end Player.Graphics2d;
