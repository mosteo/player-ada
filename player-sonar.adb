with player.Aux;

with Interfaces; use Interfaces;

package body Player.Sonar is

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
      pragma Import (C, C_Create, "playerc_sonar_create");
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
      pragma Import (C, C_Subscribe, "playerc_sonar_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_sonar_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   -----------------
   -- Update_Geom --
   -----------------

   procedure Update_Geom (This : in out Object) is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "playerc_sonar_get_geom");
   begin
      Aux.Check (Internal (-This));
   end Update_Geom;

   --------------------
   -- Get_Pose_Count --
   --------------------

   function Get_Pose_Count (This : in Object) return Natural is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "player_ada_sonar_get_pose_count");
   begin
      return Natural( Internal (-This));
   end Get_Pose_Count;

   --------------
   -- Get_Pose --
   --------------

   function Get_Pose (This : in Object; Idx : in Positive) return Pose_3d is
      procedure Internal (This : Types.Handle;
                          Index : in C.Int;
                          X, Y, Z, Roll, Pitch, Yaw : out C.Double);
      pragma Import (C, Internal, "player_ada_sonar_get_pose");
      P : Pose_3d;
   begin
      Internal (-This,
                C.Int (Idx - 1),
                C.Double (P.px),
                C.Double (P.py),
                C.Double (P.pz),
                C.Double (P.proll),
                C.Double (P.ppitch),
                C.Double (P.pyaw));
      return P;
   end Get_Pose;

   --------------------
   -- Get_Scan_Count --
   --------------------

   function Get_Scan_Count (This : in Object) return Natural is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "player_ada_sonar_get_scan_count");
   begin
      return Natural (Internal (-This));
   end Get_Scan_Count;

   --------------
   -- Get_Scan --
   --------------

   function Get_Scan (This : in Object; Idx : in Positive) return Double is
      function Internal (This  : Types.Handle;
                         Index : C.Int) return C.Double;
      pragma Import (C, Internal, "player_ada_sonar_get_scan");
   begin
      return Double (Internal (-This, C.Int(Idx - 1)));
   end Get_Scan;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (This : in out Object) is
   begin
      Destroy_Handle (-This);
      Clear_Handle (This);
   end Destroy;

end Player.Sonar;
