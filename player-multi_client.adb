 

with Player.Aux;

with Interfaces.C; use Interfaces;

package body Player.Multi_Client is

   subtype Ptr is Types.Handle;

   --------------
   -- Finalize --
   --------------

   procedure Finalize   (This : in out Object) is
   begin
      Destroy (This.Handle);
   end Finalize;

   procedure Initialize (This : in out Object) is
   begin
      This.Handle := Create;
   end Initialize;

   function Get_Handle (This : in Object) return Types.Handle is
   begin
      return This.Handle;
   end Get_Handle;

   ----------
   -- Peek --
   ----------

   function Peek (This : in Object; Timeout : in Duration := 0.0)
                  return Boolean
   is
      function C_Peek (This : in Ptr; Timeout : in C.int) return C.int;
      pragma Import (C, C_Peek, "playerc_mclient_peek");

      Ret : constant C.int := C_Peek (This.Handle, C.Int (Timeout * 1000.0));
      use type C.int;
   begin
      if Ret = -1 then
         Aux.Check (-1); -- Force exception.
         return False;    -- Non reachable.
      else
         return Ret = 1;
      end if;
   end Peek;

   ----------
   -- Read --
   ----------

   procedure Read (This : in out Object; Timeout : in Duration := -1.0) is
      function C_Read (This : in Ptr; Timeout : in C.int) return C.int;
      pragma Import (C, C_Read, "playerc_mclient_read");
   begin
      Aux.Check (C_Read (This.Handle, C.Int (Timeout * 1000.0)));
   end Read;

end Player.Multi_Client;
