
with Player.Exceptions;

with Ada.Exceptions;
with Ada.Unchecked_Deallocation;
with Interfaces;
use  Interfaces;

package body Player.Aux is

   use type C.Int;

   type Node;
   type Node_Access is access Node;
   type Node is record
      Next : Node_Access;
      Str  : C.Strings.Chars_Ptr;
   end record;

   --  This keeps copies of Strings C-ified, so they're foreignly accessible.
   --  You should free them at appropriate moments.
   protected Copies is
      procedure Add (S : in String; Ptr : out C.Strings.Chars_Ptr);
      procedure Free;
   private
      First : Node_Access;
   end Copies;

   protected body Copies is

      ---------
      -- Add --
      ---------

      procedure Add (S : in String; Ptr : out C.Strings.Chars_Ptr) is
      begin
         Ptr := C.Strings.New_String (S);
         declare
            New_Node : constant Node_Access := new Node'(First, Ptr);
         begin
            First := New_Node;
         end;
      end Add;

      ----------
      -- Free --
      ----------

      procedure Free is

         ------------
         -- Delete --
         ------------

         procedure Delete is new Ada.Unchecked_Deallocation (Node, Node_Access);

         Pos, Next : Node_Access := First;
      begin
         while Pos /= null loop
            Next := Pos.Next;
            C.Strings.Free (Pos.Str);
            Delete (Pos);
            Pos := Next;
         end loop;
         First := null;
      end Free;
   end Copies;

   -----------
   -- Check --
   -----------

   procedure Check (I : in C.Int) is
   begin
      if I = -1 then
         Ada.Exceptions.Raise_Exception
           (Player.Exceptions.Player_Error'Identity,
            Player.Exceptions.Error_Str);
      end if;
   end Check;

   ----------------
   -- Check_Fail --
   ----------------

   procedure Check_Fail is
   begin
      Check (-1);
   end Check_Fail;

   ------------------
   -- Free_Strings --
   ------------------

   procedure Free_Strings is
   begin
      Copies.Free;
   end Free_Strings;

   ----------
   -- To_C --
   ----------

   function To_C (S : in String) return Interfaces.C.Strings.Chars_Ptr is
      Ptr : C.Strings.Chars_Ptr;
   begin
      Copies.Add (S, Ptr);
      return Ptr;
   end To_C;

end Player.Aux;
