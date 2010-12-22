with Player.Graphics2d.Buffered;

package Player.Graphics2d.Double is

   --  Avoid stage flickering by double buffering.
   --  You need to create two different models sharing the same
   --  reference frame, with consecutive indexes. This is due to a lone model
   --  sharing its paint queue with all its clients.

   --  E.g.:
   --  stage.world:
   --     position (
   --       size [0 0]
   --       pose [0 0 0]
   --       name "transit1"
   --     ) # Used to draw changing elements with double buffering
   --     position (
   --       Size [0 0]
   --       pose [0 0 0]
   --       name "transit2"
   --     ) # Used to draw changing elements with double buffering


   --  player.cfg:
   --  driver(
   --   name "stage"
   --   provides ["7780:graphics2d:0" "7780:position2d:0"]
   --   model "permanent1"
   --  )
   --  driver(
   --   name "stage"
   --   provides ["7780:graphics2d:1" "7780:position2d:1"]
   --   model "permanent2"
   --  )

   --  In the avobe example, the position2d are needed because otherwise the
   --  reading on the graphics2d client blocks, even in pull mode!!


   pragma Elaborate_Body;

   type Object is new Graphics2d.Object with private;

   overriding
   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   overriding
   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   overriding
   procedure Unsubscribe  (This : in out Object);

   overriding
   procedure Clear (This : in out Object);
   --  This forces a clearing. Not needed if you only want a redraw.
   --  In that case, flush switches the visible canvas and takes care of
   --  clearing off-screen canvases.

   overriding
   procedure Set_Color (This  : in out Object;
                        Color : in     Types.Player_Color_Type);

   overriding
   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Array);

   overriding
   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Vector);

   overriding
   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Array);

   overriding
   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Vector);

   not overriding
   procedure Flush (This : in out Object);
   --  Causes switch and draw. No need to use Clear.

private

   type Parent_Access is access all Graphics2d.Buffered.Object;

   type Canvases_Range is mod 2;
   type Canvases_Array is array (Canvases_Range) of Parent_Access;

   type Object is new Graphics2d.Object with record
      Canvases : Canvases_array;
      Active   : Canvases_Range := Canvases_Range'First;
   end record;

end Player.Graphics2d.Double;
