with Ada.Containers.Indefinite_Doubly_Linked_Lists;

package Player.Graphics2d.Buffered is

   --  Keeps a queue of pending actions in order to minimize flickering

   pragma Elaborate_Body;

   type Object is new Graphics2d.Object with private;

   overriding
   procedure Clear (This : in out Object);

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

private

   type Parent_Access is access all Graphics2d.Object;

   type Action_Kinds is (Clear, Set_Color,
                         Polyline_Array, Polyline_Vector,
                         Fill_Array, Fill_Vector);

   type Action (Kind : Action_Kinds;
                Last : Natural) is record
      case Kind is
         when Clear =>
            null;
         when Set_Color =>
            Color : Types.Player_Color_Type;
         when Polyline_Array =>
            Point_Array : Types.Point_2d_Array (1 .. Last);
         when Polyline_Vector =>
            Point_Vector : Types.Point_2d_Vector;
         when Fill_Array =>
            Fill_Arr  : Types.Point_2d_Array (1 .. Last);
         when Fill_Vector =>
            Fill_Vec  : Types.Point_2d_Vector;
      end case;
   end record;

   package Action_Lists is new
     Ada.Containers.Indefinite_Doubly_Linked_Lists (Action);

   subtype Action_List is Action_Lists.List;

   type Object is new Graphics2d.Object with record
      Pending : Action_List;
   end record;

   procedure Perform (This : in out Graphics2d.Object;
                      Act  :        Action);

end Player.Graphics2d.Buffered;
