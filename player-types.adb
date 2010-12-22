

package body Player.Types is

   -------------
   -- Is_Null --
   -------------

   function Is_Null (This : in Handle) return Boolean is
   begin
      return This = null;
   end Is_Null;

   --------------
   -- Set_Null --
   --------------

   procedure Set_Null (This : in out Handle) is
   begin
      This := null;
   end Set_Null;

   ---------------
   -- To_Vector --
   ---------------

   function To_Vector (P : Point_2d_Array) return Point_2d_Vector is
      V : Point_2d_Vector;
   begin
      for I in P'Range loop
         V.Append (P (I));
      end loop;
      return V;
   end To_Vector;

end Player.Types;
