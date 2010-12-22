 

--  Auxiliary things for data printing and so on.

package Player.Debug is

   pragma Elaborate_Body;

   procedure Dump_HPose (D : in HPose; Label : in String := "");

   procedure Dump_Pose (D : in Pose; Label : in String := "");

   function To_String (D : in Double) return String;
   --  Returns a readable (i.e. non scientific) representation with two decimals.

   function To_String (D : in Pose) return String;

end Player.Debug;
