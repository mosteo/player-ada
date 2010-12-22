with Interfaces.C; use Interfaces;
with Player.Aux;

package body Player.Gps is

   use type I.C.Double;

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
      pragma Import (C, C_Create, "playerc_gps_create");
   begin
      Interfaces.Create (Interfaces.Object (This), Conn, Index);
      Set_Handle (This, C_Create (Client.Get_Handle (Conn), C.int (Index)));
   end Create;

   ---------------
   -- Subscribe --
   ---------------

   procedure Subscribe (This : in out Object; Mode : in Access_Modes) is
      function C_Subscribe (This : in Types.Handle; Mode : in Access_Modes)
                            return C.int;
      pragma Import (C, C_Subscribe, "playerc_gps_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_gps_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (This : in out Object) is
   begin
      Destroy_Handle (-This);
      Clear_Handle (This);
   end Destroy;

end Player.Gps;
