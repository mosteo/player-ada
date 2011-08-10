

--  Root class for interfaces.
--  When extending these, each interface should provide its own Subscribe and
--  Unsubscribe. These should call, as a final step, this root implementation.

with Player.Client;
with Player.Types;

with Ada.Finalization;
with Interfaces;
use Interfaces;

package Player.Interfaces is

   pragma Linker_Options ("-lm");
   pragma Linker_Options ("-lplayerc");

   pragma Elaborate_Body;

   type Object is abstract tagged limited private;

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);
   --  This must call the C native constructor.
   --  Must, as first step, call this Create.

   procedure Destroy      (This : in out Object)
   is abstract;
   --  This must call the C native destructor.
   --  Must also ensure that the handle is set to null.
   --  Failure to do so will cause destructor misbehavior.

   procedure Clear_Handle (This : in out Object);

   function  Get_Handle   (This : in Object) return Types.Handle;
   function  "-"          (This : in Object) return Types.Handle
                           renames Get_Handle;

   procedure Set_Handle   (This : in out Object; Handle : in Types.Handle);

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

   function  Get_Fresh    (This : in Object) return C.Int;

   procedure Set_Fresh    (This : in out Object; Fresh : in C.Int);

private

   type Object is abstract new Ada.Finalization.Limited_Controlled with record
      Handle     : Types.Handle;
      Subscribed : Boolean := False;
   end record;

   procedure Finalize (This : in out Object);

   pragma Inline (Clear_Handle,
                  Get_Handle,
                  Set_Handle,
                  Subscribe,
                  Unsubscribe);

end Player.Interfaces;
