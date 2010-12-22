 

with Text_Io;

package body Player.Debug is

   type Printable is delta 0.01 digits 18;

   ----------------
   -- Dump_HPose --
   ----------------

   procedure Dump_HPose (D : in HPose; Label : in String := "") is
   begin
      Text_Io.Put_Line (Label &
                        " X =" & Debug.To_String (D (1)) &
                        "; Y =" & Debug.To_String (D (2)) &
                        "; A =" & Debug.To_String (D (3)) &
                        "; H =" & Debug.To_String (D (4))
                       );
   end Dump_HPose;

   procedure Dump_Pose (D : in Pose; Label : in String := "") is
   begin
      Text_Io.Put_Line (Label &
                        " X =" & Debug.To_String (D (1)) &
                        "; Y =" & Debug.To_String (D (2)) &
                        "; A =" & Debug.To_String (D (3)));
   end Dump_Pose;

   ---------------
   -- To_String --
   ---------------

   function To_String (D : in Double) return String is
   begin
      return Printable'Image (Printable (D));
   end To_String;

   function To_String (D : in Pose) return String is
   begin
      return " X =" & Debug.To_String (D (1)) &
             "; Y =" & Debug.To_String (D (2)) &
             "; A =" & Debug.To_String (D (3));
   end To_String;

end Player.Debug;
