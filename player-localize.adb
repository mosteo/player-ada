with Player.Aux;
with Interfaces.C; use Interfaces;

package body Player.Localize is

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
      pragma Import (C, C_Create, "playerc_localize_create");
   begin
      Interfaces.Create (Interfaces.Object (This), Conn, Index);
      Set_Handle (This, C_Create (Client.Get_Handle (Conn), C.int (Index)));
   end Create;

   --------------------
   -- Get_Hypotheses --
   --------------------

   function Get_Hypotheses (This : Object) return Hypothesis_Array is
      function Count (This : Types.Handle) return C.int;
      pragma Import (C, Count, "player_ada_localize_get_hypo_count");
      procedure Get (This    : Types.Handle;
                     I       : C.int;
                     X, Y, A : out C.double;
                     Cx, Cy, Ca : out C.double;
                     Weight     : out C.double);
      pragma Import (C, Get, "player_ada_localize_get_hypo");

      Hyps : Hypothesis_Array (1 .. Natural (Count (-This)));
   begin
      for I in Hyps'Range loop
         Get (-This, C.int (I - 1),
              C.double (Hyps (I).Mean (1)),
              C.double (Hyps (I).Mean (2)),
              C.double (Hyps (I).Mean (3)),
              C.double (Hyps (I).Cov (1)),
              C.double (Hyps (I).Cov (2)),
              C.double (Hyps (I).Cov (3)),
              C.double (Hyps (I).Weight));
      end loop;

      return Hyps;
   end Get_Hypotheses;

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
      pragma Import (C, C_Subscribe, "playerc_localize_subscribe");
   begin
      Aux.Check (C_Subscribe (-This, Mode));
      Interfaces.Subscribe (Interfaces.Object (This), Mode);
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
      function C_Unsubscribe (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Unsubscribe, "playerc_localize_unsubscribe");
   begin
      Aux.Check (C_Unsubscribe (-This));
      Interfaces.Unsubscribe (Interfaces.Object (This));
   end Unsubscribe;

   --------------
   -- Set_Pose --
   --------------

--     procedure Set_Pose
--       (This : in out Object;
--        Pose : in     Player.Pose;
--        Cov  : in     Covariance)
--     is
--        function C_Set_Pose
--          (This : in Types.Handle; Pose : in Player.Pose; Cov : in Covariance)
--           return C.int;
--        pragma Import (C, C_Set_Pose, "playerc_localize_set_pose");
--     begin
--        Aux.Check (C_Set_Pose (-This, Pose, Cov));
--     end Set_Pose;

end Player.Localize;
