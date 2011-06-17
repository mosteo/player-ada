with player.Aux;

package body Player.Laser is

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
      pragma Import (C, C_Create, "playerc_laser_create");
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
      pragma Import (C, C_Subscribe, "playerc_laser_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_laser_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   ----------------
   -- Set_Config --
   ----------------

   procedure Set_Config
     (This       : in out Object;
      Min_Angle,
      Max_Angle  : in Double;
      Resolution : in Double;
      Range_Res  : in Double;
      Intensity  : in Boolean;
      Frequency  : in Double)
   is
      function C_Set_Config
        (This : in Types.Handle;
         Min,
         Max  : in C.double;
         Res  : in C.double;
         Rang : in C.double;
         Inte : in C.unsigned_char;
         Freq : in C.double) return C.int;
      pragma Import (C, C_Set_Config, "playerc_laser_set_config");
   begin
      Aux.Check (C_Set_Config
        (-This,
           C.double (Min_Angle), C.double (Max_Angle),
           C.double (Resolution),
           C.double (Range_Res),
           C.unsigned_char (Boolean'Pos (Intensity)),
           C.double (frequency)));
   end Set_Config;

   ----------------
   -- Get_Config --
   ----------------

   procedure Get_Config
     (This       : in Object;
      Min_Angle,
      Max_Angle  : out Double;
      Resolution,
      Range_Res  : out Double;
      Intensity  : out Boolean;
      Frequency  : out Double)
   is
      procedure C_Get_Config
        (Val  : out C.int;
         This : in Types.Handle;
         Min,
         Max  : out C.double;
         Res  : out C.double;
         Rang : out C.double;
         Inte : out C.unsigned_char;
         Freq : out C.double);
      pragma Import (C, C_Get_Config, "playerc_laser_get_config");
      pragma Import_Valued_Procedure (C_Get_Config);

      Min, Max, Freq  : C.double;
      Res, Rang       : C.double;
      Inte            : C.Unsigned_Char;
      Val             : C.int;
      use type C.Int, C.Unsigned_Char;
   begin
      C_Get_Config (Val, -This, Min, Max, Res, Rang, Inte, Freq);
      Aux.Check (Val);
      Min_Angle  := Double (Min);
      Max_Angle  := Double (Max);
      Resolution := Double (Res);
      Range_Res  := Double (Rang);
      Intensity  := Inte /= 0;
      Frequency  := Double (Freq);
   end Get_Config;

   --------------
   -- Get_Pose --
   --------------

   function Get_Pose (This : in Object) return Pose is
      procedure Internal (This : Types.Handle; X, Y, A : out C.Double);
      pragma Import (C, Internal, "player_ada_laser_get_geom");
      P : Pose;
   begin
      Aux.Check (Update_Geom (-This));
      Internal (-This,
                C.Double (P (P'First)),
                C.Double (P (P'First + 1)),
                C.Double (P (P'First + 2)));
      pragma Untested ("Not tested, not sure that access paths can't play havoc here");
      return P;
   end Get_Pose;

   --------------
   -- Get_Size --
   --------------

   function Get_Size (This : in Object) return Double_Array is
      procedure Internal (This : Types.Handle; X, Y : out C.Double);
      pragma Import (C, Internal, "player_ada_laser_get_size");
      S : Double_Array (1 .. 2);
   begin
      Aux.Check (Update_Geom (-This));
      Internal (-This, C.Double (S (1)), C.Double (S(2)));
      return S;
   end Get_Size;

   --------------------
   -- Get_Scan_Count --
   --------------------

   function Get_Scan_Count (This : in Object) return Natural is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "player_ada_laser_scan_count");
   begin
      return Natural (Internal (-This));
   end Get_Scan_Count;

   --------------------
   -- Get_Scan_Start --
   --------------------

   function Get_Scan_Start (This : in Object) return Double is
      function Internal (This : Types.Handle) return C.Double;
      pragma Import (C, Internal, "player_ada_laser_scan_start");
   begin
      return Double (Internal (-This));
   end Get_Scan_Start;

   ------------------
   -- Get_Scan_Res --
   ------------------

   function Get_Scan_Res (This : in Object) return Double is
      function Internal (This : Types.Handle) return C.Double;
      pragma Import (C, Internal, "player_ada_laser_scan_res");
   begin
      return Double (Internal (-This));
   end Get_Scan_Res;

   -------------------
   -- Get_Range_Res --
   -------------------

   function Get_Range_Res (This : in Object) return Double is
      function Internal (This : Types.Handle) return C.Double;
      pragma Import (C, Internal, "player_ada_laser_range_res");
   begin
      return Double (Internal (-This));
   end Get_Range_Res;

   -------------------
   -- Get_Max_Range --
   -------------------

   function Get_Max_Range (This : in Object) return Double is
      function Internal (This : Types.Handle) return C.Double;
      pragma Import (C, Internal, "player_ada_laser_max_range");
   begin
      return Double (Internal (-This));
   end Get_Max_Range;

   --------------
   -- Get_Scan --
   --------------

   function Get_Scan (This : in Object; Idx : in Positive) return Scan is
      procedure Internal (This       : Types.Handle;
                          Index      : C.Int;
                          R, B, X, Y : out C.Double;
                          Intensity  : out C.Int);
      pragma Import (C, Internal, "player_ada_laser_get_scan");
      S : Scan;
      pragma Untested ("I'm wary of multiple access paths to the same record below");
   begin
      Internal
        (-This,
         C.Int (Idx - 1),
         C.Double (S.Rang), C.Double (S.Bearing),
         C.Double (S.X), C.Double (S.Y),
         C.Int (S.Intensity));
      return S;
   end Get_Scan;

   -----------------
   -- Get_Scan_Id --
   -----------------

   function Get_Scan_Id (This : in Object) return Integer is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "player_ada_laser_get_scan_id");
   begin
      return Integer (Internal (-This));
   end Get_Scan_Id;

   -------------------
   -- Get_Min_Right --
   -------------------

   function Get_Min_Right (This : in Object) return Double is
      function Internal (This : Types.Handle) return C.Double;
      pragma Import (C, Internal, "player_ada_laser_get_min_right");
   begin
      return Double (Internal (-This));
   end Get_Min_Right;

   ------------------
   -- Get_Min_Left --
   ------------------

   function Get_Min_Left (This : in Object) return Double is
      function Internal (This : Types.Handle) return C.Double;
      pragma Import (C, Internal, "player_ada_laser_get_min_left");
   begin
      return Double (Internal (-This));
   end Get_Min_Left;

   --------------------
   -- Get_Robot_Pose --
   --------------------

   function Get_Robot_Pose (This : in Object) return Pose is
      procedure Internal (This : Types.Handle;
                          X, Y, A : out C.Double);
      pragma Import (C, Internal, "player_ada_laser_get_robot_pose");
      pragma Untested ("As others, multiple access paths into same struct :S");
      P : Pose;
   begin
      Internal (-This,
                C.Double (P (P'First)),
                C.Double (P (P'First + 1)),
                C.Double (P (P'First + 2)));
      return P;
   end Get_Robot_Pose;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (This : in out Object) is
   begin
      Destroy_Handle (-This);
      Clear_Handle (This);
   end Destroy;

end Player.Laser;
