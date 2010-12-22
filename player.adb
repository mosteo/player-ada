package body Player is

   ---------
   -- "-" --
   ---------

   function "-" (D : in Double_Array) return Double_Array is
      R : Double_Array (D'Range);
   begin
      for I in D'Range loop
         R (I) := -D (I);
      end loop;

      return R;
   end "-";

end Player;
