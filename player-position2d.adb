with Player.Aux;

--  with Player.Debug;

package body Player.Position2d is

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
      pragma Import (C, C_Create, "playerc_position2d_create");
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
      pragma Import (C, C_Subscribe, "playerc_position2d_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_position2d_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   ------------
   -- Enable --
   ------------

   procedure Enable
     (This    : in out Object;
      Enabled : in     Boolean := True)
   is
      function C_Enable (This   : in Types.Handle;
                         Enable : in C.int) return C.Int;
      pragma Import (C, C_Enable, "playerc_position2d_enable");
   begin
      Aux.Check (C_Enable (-This, Enabling (Enabled)));
   end Enable;

   --------------
   -- Get_Geom --
   --------------

   procedure Get_Geom (This : in Object; X, Y, A : out Double) is
      procedure Internal (This : Types.Handle;
                          X, Y, A : out C.Double);
      pragma Import (C, Internal, "player_ada_position2d_get_geom");
   begin
      Internal (-This,
                C.Double (X), C.Double (Y), C.Double (A));
   end Get_Geom;

   --------------
   -- Get_Size --
   --------------

   procedure Get_Size (This : in Object; W, H : out Double) is
      procedure Internal (This : Types.Handle;
                          W, H : out C.Double);
      pragma Import (C, Internal, "player_ada_position2d_get_size");
   begin
      Internal (-This, C.Double (W), C.Double (H));
   end Get_Size;

   --------------
   -- Get_Pose --
   --------------

   procedure Get_Pose (This : in Object; X, Y, A : out Double) is
      procedure Internal (This : Types.Handle;
                          X, Y, A : out C.Double);
      pragma Import (C, Internal, "player_ada_position2d_get_pose");
   begin
      Internal (-This, C.Double (X), C.Double (Y), C.Double (A));
   end Get_Pose;

   function  Get_Pose (This : in Object) return Pose is
      X, Y, A : Double;
   begin
      Get_Pose (This, X, Y, A);
      return (X, Y, A);
   end Get_Pose;

   ------------------
   -- Get_Velocity --
   ------------------

   procedure Get_Velocity (This : in Object; X, Y, A : out Double) is
      procedure Internal (This : Types.Handle;
                          X, Y, A : out C.Double);
      pragma Import (C, Internal, "player_ada_position2d_get_velo");
   begin
      Internal (-This, C.Double (X), C.Double (Y), C.Double (A));
   end Get_Velocity;

   function  Get_Velocity (This : in Object) return Velo is
      X, Y, A : Double;
   begin
      Get_Velocity (This, X, Y, A);
      return (X, Y, A);
   end Get_Velocity;

   -----------------
   -- Get_Stalled --
   -----------------

   function Get_Stalled (This : in Object) return Boolean is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "player_ada_position2d_get_stalled");
      use type Standard.Interfaces.C.Int;
   begin
      return Internal (-This) /= 0;
   end Get_Stalled;

   --------------
   -- Set_Pose --
   --------------

   procedure Set_Pose (This    : in Object;
                       X, Y, A : in Double)
   is
      function Internal (This    : Types.Handle;
                         X, Y, A : C.Double) return C.Int;
      pragma Import (C, Internal, "playerc_position2d_set_odom");
   begin
      Aux.Check (Internal (-This, C.Double (X), C.Double (Y), C.Double (A)));
   end Set_Pose;

   --------------
   -- Set_Pose --
   --------------

   procedure Set_Pose (This    : in Object;
                       P       : in Pose) is
   begin
      Set_Pose (This, P (P'First), P (P'First + 1), P (P'First + 2));
   end Set_Pose;

   -----------------
   -- Set_Cmd_Vel --
   -----------------

   procedure Set_Cmd_Vel
     (This    : in Object;
      X, Y, A : in Double;
      Enable  : in Boolean := True)
   is
      function C_Set_Cmd_Vel
        (This    : in Types.Handle;
         X, Y, A : in C.double;
         Enable  : in C.int) return C.Int;
      pragma Import (C, C_Set_Cmd_Vel, "playerc_position2d_set_cmd_vel");
--      use Debug;
   begin
      Aux.Check (C_Set_Cmd_Vel
                   (-This,
                    C.double (X), C.double (Y), C.double (A),
                    Enabling (Enable)));
   end Set_Cmd_Vel;

   ------------------
   -- Set_Cmd_Pose --
   ------------------

   procedure Set_Cmd_Pose
     (This    : in Object;
      X, Y, A : in Double;
      Enable  : in Boolean := True)
   is
      function C_Set_Cmd_Pose
        (This    : in Types.Handle;
         X, Y, A : in C.double;
         Enable  : in C.int) return C.Int;
      pragma Import (C, C_Set_Cmd_Pose, "playerc_position2d_set_cmd_pose");
   begin
      Aux.Check (C_Set_Cmd_Pose
                   (-This,
                    C.double (X), C.double (Y), C.double (A),
                    Enabling (Enable)));
   end Set_Cmd_Pose;

   -----------------
   -- Set_Cmd_Vel --
   -----------------

   procedure Set_Cmd_Vel
     (This    : in Object;
      P       : in Pose;
      Enable  : in Boolean := True) is
   begin
      Set_Cmd_Vel (This, P (P'First), P (P'First + 1), P (P'First + 2), Enable);
   end Set_Cmd_Vel;

   ------------------
   -- Set_Cmd_Pose --
   ------------------

   procedure Set_Cmd_Pose
     (This    : in Object;
      P       : in Pose;
      Enable  : in Boolean := True) is
   begin
      Set_Cmd_Pose
        (This, P (P'First), P (P'First + 1), P (P'First + 2), Enable);
   end Set_Cmd_Pose;

end Player.Position2d;
