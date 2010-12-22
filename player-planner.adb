with Interfaces;
with Player.Aux;

package body Player.Planner is

   use type Standard.Interfaces.C.int;

   ------------
   -- Create --
   ------------

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0)
   is
      function C_Create (Conn : in Types.Handle; Index : in I.C.int)
                         return Types.Handle;
      pragma Import (C, C_Create, "playerc_planner_create");
   begin
      Interfaces.Create (Interfaces.Object (This), Conn, Index);
      Set_Handle (This, C_Create (Client.Get_Handle (Conn), I.C.int (Index)));
   end Create;

   ---------------
   -- Subscribe --
   ---------------

   procedure Subscribe (This : in out Object; Mode : in Access_Modes) is
      function C_Subscribe (This : in Types.Handle; Mode : in Access_Modes)
                            return I.C.int;
      pragma Import (C, C_Subscribe, "playerc_planner_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return I.C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_planner_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   ------------
   -- Enable --
   ------------

   procedure Enable
     (This : in out Object;
      Enabled : in Boolean := True)
   is
      function C_Enable (This : in Types.Handle; Enable : in I.C.Int) return I.C.Int;
      pragma Import (C, C_Enable, "playerc_planner_enable");
   begin
      Aux.Check (C_Enable (-This, Enabling (Enabled)));
   end Enable;

   ------------------
   -- Set_Cmd_Pose --
   ------------------

   procedure Set_Cmd_Pose
     (This    : in Object;
      X, Y, A : in Double)
   is
      function C_Set_Cmd_Pose
        (This    : in Types.Handle;
         X, Y, A : in I.C.double) return I.C.Int;
      pragma Import (C, C_Set_Cmd_Pose, "playerc_planner_set_cmd_pose");
   begin
      Aux.Check (C_Set_Cmd_Pose
                   (-This,
                    I.C.double (X), I.C.double (Y), I.C.double (A)));
   end Set_Cmd_Pose;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (This : in out Object) is
   begin
      Destroy_Handle (-This);
      Clear_Handle (This);
   end Destroy;

end Player.Planner;
