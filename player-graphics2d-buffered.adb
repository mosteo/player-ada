package body Player.Graphics2d.Buffered is

   procedure Clear (This : in out Object) is
   begin
      This.Pending.Append (Action'(Clear, 0));
   end Clear;

   procedure Set_Color (This  : in out Object;
                        Color : in     Types.Player_Color_Type)
   is
   begin
      This.Pending.Append (Action'(Set_Color, 0, Color));
   end Set_Color;

   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Array)
   is
   begin
      This.Pending.Append
        (Action'
           (Polyline_Array,
            Points'Length,
            Points));
   end Draw_Polyline;

   procedure Draw_Polyline (This   : in out Object;
                            Points : in     Types.Point_2d_Vector) is
   begin
      This.Pending.Append
        (Action'
           (Polyline_Vector,
            Natural (Points.Length),
            Points));
   end Draw_Polyline;

   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Array) is
   begin
      This.Pending.Append
        (Action'
           (Fill_Array,
            Natural (Points'Length),
            Points));
   end Fill_Polygon;

   procedure Fill_Polygon (This   : in out Object;
                           Points : in     Types.Point_2d_Vector) is
   begin
      This.Pending.Append
        (Action'
           (Fill_Vector,
            Natural (Points.Length),
            Points));
   end Fill_Polygon;

   procedure Flush (This : in out Object) is
      use Action_Lists;
      I : Cursor := Action_Lists.First (This.Pending);
   begin
      while Has_Element (I) loop
         Perform (Graphics2d.Object (This), Element (I));
         Next (I);
      end loop;
      This.Pending.Clear;
   end Flush;

   procedure Perform (This : in out Graphics2d.Object;
                      Act  :        Action)
   is
   begin
      case Act.Kind is
         when Clear =>
            This.Clear;
         when Set_Color =>
            This.Set_Color (Act.Color);
         when Polyline_Array =>
            This.Draw_Polyline (Act.Point_Array);
         when Polyline_Vector =>
            This.Draw_Polyline (Act.Point_Vector);
         when Fill_Array =>
            This.Fill_Polygon (Act.Fill_Arr);
         when Fill_Vector =>
            This.Fill_Polygon (Act.Fill_Vec);
      end case;
   end Perform;

end Player.Graphics2d.Buffered;
