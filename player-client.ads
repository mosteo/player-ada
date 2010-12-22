 

--  Client connections

with Player.Multi_Client;
with Player.Types;

with Ada.Finalization;

package Player.Client is

   pragma Elaborate_Body;

   type Connection_Type is tagged limited private;
   subtype Object is Connection_Type;
   --  playerc_client_t *

   type Object_Access is access all Object;

   procedure Create
     (Conn    : in out Connection_Type;
      Manager : in out Multi_Client.Object;
      Host    : in     String   := "127.0.0.1";
      Port    : in     Positive := 6665);

   procedure Create
     (Conn : in out Connection_Type;
      Host : in     String   := "127.0.0.1";
      Port : in     Positive := 6665);
   --  Creation for stand alone use.

   procedure Connect (This : in out Connection_Type);

   procedure Disconnect (This : in out Connection_Type);

   --  Data connection modes for proxies:
   function Datamode_Push return Integer;
   function Datamode_Pull return Integer;

   pragma Import (C, Datamode_Push, "Playerc_Datamode_Push");
   pragma Import (C, Datamode_Pull, "Playerc_Datamode_Pull");

   subtype Connection_Modes is Integer range DATAMODE_PUSH .. DATAMODE_PULL;

   procedure Datamode
     (This : in out Connection_Type;
      Mode : in     Connection_Modes);

   function Peek (This : in Connection_Type; Timeout : in Duration := 0.0)
                  return Boolean;

   function Get_Handle (This : in Connection_Type) return Types.Handle;

   procedure Read
     (This : in out Connection_Type;
      Dest :    out Types.Handle);

   procedure Read (This : in out Connection_Type);
   --  As previous but returned value is ignored

   procedure Set_Replace_Rule (This        : in out Connection_Type;
                               Iface,
                               Index,
                               Msg_Type,
                               Msg_Subtype : in     Integer;
                               Replace     : in     Boolean);
   --  Use -1 for wilcard

   procedure Set_Request_Timeout (This    : in out Connection_Type;
                                  Seconds : in     Natural);

private

   type Connection_Type is new Ada.Finalization.Limited_Controlled with record
      Handle    : Types.Handle;
      Connected : Boolean := False;
   end record;

   procedure Finalize   (This : in out Connection_Type);

   procedure Destroy (This : in Types.Handle);
   pragma Import (C, Destroy, "playerc_client_destroy");

   -- DEPRECATED --

--     procedure Datafreq
--       (This : in out Connection_Type;
--        Freq : in Positive);
   --  In Hertz


end Player.Client;
