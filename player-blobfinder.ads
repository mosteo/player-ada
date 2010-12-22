--  Blobfinder proxy interface

with Player.Client;
with Player.Interfaces;
with Player.Types;

package Player.Blobfinder is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   overriding
   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   overriding
   procedure Unsubscribe  (This : in out Object);

--     function Get_Image_Width (This : in Object) return Natural;
--     function Get_Image_Height (This : in Object) return Natural;
--
--     function Get_Blob_Count (This : in Object) return Natural;
--
--     function Get_Blobs (This : in Object) return Blob_Array;

private

   overriding
   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_blobfinder_destroy");

end Player.Blobfinder;
