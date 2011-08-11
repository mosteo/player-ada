with Interfaces.C;

package body Player.Interfaces is

   ------------
   -- Create --
   ------------

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0)
   is
      pragma Unreferenced (Conn);
      pragma Unreferenced (Index);
   begin
      Finalize (This);
   end Create;

   ------------------
   -- Clear_Handle --
   ------------------

   procedure Clear_Handle (This : in out Object) is
   begin
      Types.Set_Null (This.Handle);
   end Clear_Handle;

   ----------------
   -- Get_Handle --
   ----------------

   function Get_Handle (This : in Object) return Types.Handle is
   begin
      return This.Handle;
   end Get_Handle;

   ----------------
   -- Set_Handle --
   ----------------

   procedure Set_Handle (This : in out Object; Handle : in Types.Handle) is
   begin
      This.Handle := Handle;
   end Set_Handle;

   ---------------
   -- Subscribe --
   ---------------

   procedure Subscribe (This : in out Object; Mode : in Access_Modes) is
      pragma Unreferenced (Mode);
   begin
      This.Subscribed := True;
   end Subscribe;

   -----------------
   -- Unsubscribe --
   -----------------

   procedure Unsubscribe (This : in out Object) is
   begin
      This.Subscribed := False;
   end Unsubscribe;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (This : in out Object) is
   begin
      if not Types.Is_Null (This.Handle) then
         if This.Subscribed then
            Unsubscribe (Object'Class (This));
         end if;
         Destroy (Object'Class (This));
      end if;
   end Finalize;

   ---------------
   -- Get_Fresh --
   ---------------

   function Get_Fresh (This : in Object) return C.Int is
      function Internal (This : Types.Handle) return C.Int;
      pragma Import (C, Internal, "playerc_device_get_fresh");
   begin
      return Internal(-This);
   end Get_Fresh;

   ---------------
   -- Set_Fresh --
   ---------------

   procedure Set_Fresh (This : in out Object; Fresh : in C.Int) is
      procedure Internal (This : Types.Handle; Fresh : in C.Int);
      pragma Import (C, Internal, "playerc_device_set_fresh");
   begin
      Internal(-This, Fresh);
   end Set_Fresh;

end Player.Interfaces;
