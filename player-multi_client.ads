 

--  Multiple client connections maintainer

with Player.Types;

with Ada.Finalization;

package Player.Multi_Client is

   pragma Elaborate_Body;

   type Object is limited private;
   --  playerc_mclient_t

   function Get_Handle (This : in Object) return Types.Handle;

   function Peek (This : in Object; Timeout : in Duration := 0.0)
     return Boolean;

   procedure Read (This : in out Object; Timeout : in Duration := -1.0);
   --  The negative timeout means wait indefinitely

private

   pragma Inline (Get_Handle);

   type Object is new Ada.Finalization.Limited_Controlled with record
      Handle : Types.Handle;
   end record;

   procedure Initialize (This : in out Object);
   procedure Finalize   (This : in out Object);

   function Create return Types.Handle;
   pragma Import (C, Create, "playerc_mclient_create");

   procedure Destroy (This : in Types.Handle);
   pragma Import (C, Destroy, "playerc_mclient_destroy");

end Player.Multi_Client;
