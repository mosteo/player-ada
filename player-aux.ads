 --  Auxiliary things for interfacing with C

with Interfaces.C;
with Interfaces.C.Strings;

package Player.Aux is

   pragma Elaborate_Body;

   type Void_Ptr is new Interfaces.C.Strings.Chars_Ptr;

   Bool_To_CInt : constant array (Boolean) of Interfaces.C.Int :=
                    (True => 1, False => 0);

   procedure Check (I : in Interfaces.C.Int);
   --  Will raise the Player_Error exception when I /= 0.

   procedure Check_Fail;
   --  Will always raise; = Check (-1);

   procedure Free_Strings;
   --  Release memory used by temporary copies of strings.

   function To_C (S : in String) return Interfaces.C.Strings.Chars_Ptr;
   --  Returns a pointer to the first element of a copy of the S string.
   --  Memory increases until Free_Strings is called.
   --  This allows a portable and comfortable way to use Ada strings as
   --  parameters to C functions.

end Player.Aux;
