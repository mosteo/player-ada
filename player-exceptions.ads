 

--  Root package for the binding to the C library libplayerc

package Player.Exceptions is

   pragma Preelaborate;

   Player_Error : exception;
   --  Raised whenever a call to player fails. The exception message will
   --  contain further details.

   function Error_Str return String;
   --  The last error happened when calling to player.

end Player.Exceptions;
