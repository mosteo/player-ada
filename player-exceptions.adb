 

with Interfaces.C.Strings;
use  Interfaces;

package body Player.Exceptions is

   ---------------
   -- Error_Str --
   ---------------

   function Error_Str return String is
      function C_Error return C.Strings.Chars_Ptr;
      pragma Import (C, C_Error, "playerc_error_str");
   begin
      return C.Strings.Value (C_Error);
   end Error_Str;

end Player.Exceptions;
