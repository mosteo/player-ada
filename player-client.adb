with Player.Aux;

with Interfaces.C;
with Interfaces.C.Strings; use Interfaces;

package body Player.Client is

   --------------
   -- Finalize --
   --------------

   procedure Finalize   (This : in out Connection_Type) is
   begin
      if not Types.Is_Null (This.Handle) then
         if This.Connected then
            Disconnect (This);
            This.Connected := False;
         end if;
         Destroy (This.Handle);
         Types.Set_Null (This.Handle);
      end if;
   end Finalize;

   ----------------
   -- Get_Handle --
   ----------------

   function Get_Handle (This : in Connection_Type) return Types.Handle is
   begin
      return This.Handle;
   end Get_Handle;

   ------------
   -- Create --
   ------------

   procedure Create
     (Conn    : in out Connection_Type;
      Manager : in out Multi_Client.Object;
      Host    : in     String   := "127.0.0.1";
      Port    : in     Positive := 6665)
   is
      function C_Create
        (Manager : in Types.Handle;
         Host    : in C.Strings.Chars_Ptr;
         Port    : in C.int) return Types.Handle;
      pragma Import (C, C_Create, "playerc_client_create");
   begin
      Finalize (Conn);

      Conn.Handle := C_Create
        (Multi_Client.Get_Handle (Manager),
         Aux.To_C (Host),
         C.int (Port));

      if Types.Is_Null (Conn.Handle) then
         Aux.Check_Fail;
      end if;

      Aux.Free_Strings;
   end Create;

   procedure Create
     (Conn : in out Connection_Type;
      Host : in     String   := "127.0.0.1";
      Port : in     Positive := 6665)
   is
      function C_Create
        (Manager : in Types.Handle;
         Host    : in C.Strings.Chars_Ptr;
         Port    : in C.int) return Types.Handle;
      pragma Import (C, C_Create, "playerc_client_create");

      Dummy : Types.Handle;
   begin
      Finalize (Conn);

      Conn.Handle := C_Create (Dummy, Aux.To_C (Host), C.int (Port));

      if Types.Is_Null (Conn.Handle) then
         Aux.Check_Fail;
      end if;

      Aux.Free_Strings;
   end Create;

   -------------
   -- Connect --
   -------------

   procedure Connect (This : in out Connection_Type) is
      function C_Connect (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Connect, "playerc_client_connect");
   begin
      Aux.Check (C_Connect (This.Handle));
      This.Connected := True;
   end Connect;

   ----------------
   -- Disconnect --
   ----------------

   procedure Disconnect (This : in out Connection_Type) is
      function C_Disconnect (This : in Types.Handle) return C.Int;
      pragma Import (C, C_Disconnect, "playerc_client_disconnect");
   begin
      Aux.Check (C_Disconnect (This.Handle));
      This.Connected := False;
   end Disconnect;

   --------------
   -- Datamode --
   --------------

   procedure Datamode
     (This : in out Connection_Type;
      Mode : in     Connection_Modes)
   is
      function C_Datamode (This : in Types.Handle; Mode : in C.Int)
                           return C.Int;
      pragma Import (C, C_Datamode, "playerc_client_datamode");
   begin
      Aux.Check (C_Datamode (This.Handle, C.Int (Mode)));
   end Datamode;

   --------------
   -- Datafreq --
   --------------

--     procedure Datafreq (This : in out Connection_Type; Freq : in Positive) is
--        function C_Datafreq
--          (This : in Types.Handle; Freq : in C.Int) return C.Int;
--        pragma Import (C, C_Datafreq, "playerc_client_datafreq");
--     begin
--        Aux.Check (C_Datafreq (This.Handle, C.Int (Freq)));
--     end Datafreq;

   ----------
   -- Peek --
   ----------

   function Peek (This : in Connection_Type; Timeout : in Duration := 0.0)
                  return Boolean
   is
      function C_Peek (This : in Types.Handle; Timeout : in C.Int)
                       return C.Int;
      pragma Import (C, C_Peek, "playerc_client_peek");

      use type C.int;
      Ret : constant C.int := C_Peek (This.Handle, C.Int (Timeout * 1000.0));
   begin
      if Ret = -1 then
         Aux.Check (-1);
         return False;
      else
         return Ret = 1;
      end if;
   end Peek;

   ----------
   -- Read --
   ----------

   procedure Read
     (This : in out Connection_Type;
      Dest : out    Types.Handle)
   is
      function C_Read (This : in Types.Handle)
                       return Types.Handle;
      pragma Import (C, C_Read, "playerc_client_read");
      use type C.Int;
   begin
      Dest := C_Read (This.Handle);
      if Types.Is_Null (Dest) then
         Aux.Check (-1); -- Will force a raise with the proper error msg.
      end if;
   end Read;

   ----------
   -- Read --
   ----------

   procedure Read (This : in out Connection_Type) is
      Dest : Types.Handle;
   begin
      Read (This, Dest);
   end Read;

   ----------------------
   -- Set_Replace_Rule --
   ----------------------

   procedure Set_Replace_Rule (This        : in out Connection_Type;
                               Iface,
                               Index,
                               Msg_Type,
                               Msg_Subtype : in     Integer;
                               Replace     : in     Boolean)
   is
      function C_Replace (This    : in Types.Handle;
                          Iface,
                          Index,
                          Msg_Type,
                          Msg_Subtype,
                          Replace : in C.Int) return C.Int;
      pragma Import (C, C_Replace, "playerc_client_set_replace_rule");
   begin
      Aux.Check (C_Replace (This.Handle,
                            C.Int (Iface),
                            C.Int (Index),
                            C.Int (Msg_Type),
                            C.Int (Msg_Subtype),
                            Aux.Bool_To_Cint (Replace)));
   end Set_Replace_Rule;

   -------------------------
   -- Set_Request_Timeout --
   -------------------------

   procedure Set_Request_Timeout (This    : in out Connection_Type;
                                  Seconds : in     Natural)
   is
      function C_Set (This    : in Types.Handle;
                      Seconds : in C.Unsigned) return C.int;
      pragma Import (C, C_Set, "playerc_client_set_request_timeout");
   begin
      Aux.Check (C_Set (This.Handle, C.Unsigned (Seconds)));
   end Set_Request_Timeout;

end Player.Client;
