with Ada.Text_Io;

package body Player.Graphics2d.Double is

   procedure Log (S : String) renames Ada.Text_Io.Put_Line;

   ------------
   -- Create --
   ------------

   overriding procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0)
   is
   begin
      Log ("AT CREATE");
      for I in This.Canvases'Range loop
         Log ("AT CREATE " & I'Img);
         This.Canvases (I) := new Buffered.Object;
         Log ("AT CREATE new");
         This.Canvases (I).Create (Conn,
                                   Index + Natural (I - Canvases_range'First));
         Log ("AT CREATE create idx" &
              Natural'Image (Index + Natural (I - Canvases_range'First)));
      end loop;
      Log ("After CREATE");
   end Create;

   ---------------
   -- Subscribe --
   ---------------

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes) is
   begin
      for I in This.Canvases'Range loop
         This.Canvases (I).Subscribe (Mode);
      end loop;
   end Subscribe;

   overriding
   procedure Unsubscribe  (This : in out Object) is
      begin
      for I in This.Canvases'Range loop
         This.Canvases (I).Unsubscribe;
      end loop;
   end Unsubscribe;

   -----------
   -- Clear --
   -----------

   overriding procedure Clear
     (This : in out Object)
   is
   begin
      for I in This.Canvases'Range loop
         This.Canvases (I).Clear;
         This.Canvases (I).Flush;
      end loop;
   end Clear;

   ---------------
   -- Set_Color --
   ---------------

   overriding procedure Set_Color
     (This  : in out Object;
      Color : in     Types.Player_Color_Type)
   is
   begin
      This.Canvases (This.Active).Set_Color (Color);
   end Set_Color;

   -------------------
   -- Draw_Polyline --
   -------------------

   overriding procedure Draw_Polyline
     (This   : in out Object;
      Points : in     Types.Point_2d_Array)
   is
   begin
      This.Canvases (This.Active).Draw_Polyline (Points);
   end Draw_Polyline;

   -------------------
   -- Draw_Polyline --
   -------------------

   overriding procedure Draw_Polyline
     (This   : in out Object;
      Points : in     Types.Point_2d_Vector)
   is
   begin
      This.Canvases (This.Active).Draw_Polyline (Points);
   end Draw_Polyline;

   ------------------
   -- Fill_Polygon --
   ------------------

   overriding procedure Fill_Polygon
     (This   : in out Object;
      Points : in     Types.Point_2d_Array)
   is
   begin
      This.Canvases (This.Active).Fill_Polygon (Points);
   end Fill_Polygon;

   ------------------
   -- Fill_Polygon --
   ------------------

   overriding procedure Fill_Polygon
     (This   : in out Object;
      Points : in     Types.Point_2d_Vector)
   is
   begin
      This.Canvases (This.Active).Fill_Polygon (Points);
   end Fill_Polygon;

   -----------
   -- Flush --
   -----------

   not overriding procedure Flush
     (This : in out Object)
   is
   begin
      This.Canvases (This.Active).Flush;
      This.Canvases (This.Active - 1).Clear;
      This.Canvases (This.Active - 1).Flush;
      This.Active := This.Active + 1;
   end Flush;

end Player.Graphics2d.Double;
