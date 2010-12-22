with Player.Aux;

package body Player.Graphics2d is

   package C renames Standard.Interfaces.C;

   ------------
   -- Create --
   ------------

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0)
   is
      function C_Create (Conn : in Types.Handle; Index : in C.int)
                         return Types.Handle;
      pragma Import (C, C_Create, "playerc_graphics2d_create");
   begin
      Interfaces.Create (Interfaces.Object (This), Conn, Index);
      Set_Handle (This, C_Create (Client.Get_Handle (Conn), C.int (Index)));
   end Create;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (This : in out Object) is
   begin
      Destroy_Handle (-This);
      Clear_Handle (This);
   end Destroy;

   ---------------
   -- Subscribe --
   ---------------

   procedure Subscribe (This : in out Object; Mode : in Access_Modes) is
      function C_Subscribe (This : in Types.Handle; Mode : in Access_Modes)
                            return C.int;
      pragma Import (C, C_Subscribe, "playerc_graphics2d_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_graphics2d_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Object) is
      function C_Clear (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Clear, "playerc_graphics2d_clear");
   begin
      Aux.Check (C_Clear (-This));
   end Clear;

   ---------------
   -- Set_Color --
   ---------------

   procedure Set_Color (This  : in out Object;
                        Color : in     Types.Player_Color_Type)
   is
      function Internal (This : Types.Handle;
                         A, R, G, B : C.Int) return C.Int;
      pragma Import (C, Internal, "player_ada_graphics2d_set_color");
   begin
      Aux.Check (Internal (-This,
        C.Int (Color.Alpha),
        C.Int (Color.Red),
        C.Int (Color.Green),
        C.Int (Color.Blue)));
   end Set_Color;

   ---------------
   -- Get_Color --
   ---------------

   function Get_Color (This : Object) return Types.Player_Color_Type is
      procedure Internal (This : Types.Handle;
                          A, R, G, B : access C.Int);
      pragma Import (C, Internal, "player_ada_graphics2d_get_color");
      A, R, G, B : aliased C.int;
      use Player.Types;
   begin
      Internal (-This, A'Access, R'Access, G'Access, B'Access);
      return (Alpha => Uint8 (A),
              Red   => Uint8 (R),
              Green => Uint8 (G),
              Blue  => Uint8 (B));
   end Get_Color;

   -------------------
   -- Draw_Polyline --
   -------------------

   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Array)
   is
      function C_Draw (This   : in Types.Handle;
                       Points : access Point_2d;
                       Count  : in C.Int) return C.Int;
      pragma Import (C, C_Draw, "playerc_graphics2d_draw_polyline");
   begin
      Aux.Check
        (C_Draw (-This, Points (Points'First)'Unrestricted_Access, Points'Length));
   end Draw_Polyline;

   -------------------
   -- Draw_Polyline --
   -------------------

   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Vector)
   is
      Pts : Types.Point_2d_Array (Points.First_Index .. Points.Last_Index);
   begin
      for I in Pts'Range loop
         Pts (I) := Points.Element (I);
      end loop;
      Draw_Polyline (This, Pts);
   end Draw_Polyline;

   ------------------
   -- Fill_Polygon --
   ------------------

   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Array)
   is
      function C_Draw (This   : Types.Handle;
                       Points : access Point_2d;
                       Count  : C.Int;
                       Fill   : C.Int;
                       Color  : Types.Player_Color_Type) return C.Int;
      pragma Import (C, C_Draw, "playerc_graphics2d_draw_polygon");
   begin
      Aux.Check (C_Draw (-This, Points (Points'First)'Unrestricted_Access, Points'Length, 1, This.Get_Color));
   end Fill_Polygon;

   ------------------
   -- Fill_Polygon --
   ------------------

   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Vector)
   is
      Pts : Types.Point_2d_Array (Points.First_Index .. Points.Last_Index);
   begin
      for I in Pts'Range loop
         Pts (I) := Points.Element (I);
      end loop;
      Fill_Polygon (This, Pts);
   end Fill_Polygon;

end Player.Graphics2d;
