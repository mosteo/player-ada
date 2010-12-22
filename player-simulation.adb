with Player.Aux;

--  with Player.Debug;

with Interfaces.C.Strings;

package body Player.Simulation is

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
      pragma Import (C, C_Create, "playerc_simulation_create");
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
      pragma Import (C, C_Subscribe, "playerc_simulation_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_simulation_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   ----------------
   -- Get_Pose2d --
   ----------------

   function Get_Pose2d (This : in Object; Id : in String) return Pose is
      function C_Get_Pose2d (This : in Types.Handle;
                             Id   : in C.Strings.Chars_Ptr;
                             X,
                             Y,
                             A    : access C.Double) return C.int;
      pragma Import (C, C_Get_Pose2d, "playerc_simulation_get_pose2d");

      X, Y, A : aliased C.Double;
   begin
      Aux.Check (C_Get_Pose2d (-This,
                               Aux.To_C (Id),
                               X'Access,
                               Y'Access,
                               A'Access));
      Aux.Free_Strings;
      return (Double (X), Double (Y), Double (A));
   end Get_Pose2d;

end Player.Simulation;
