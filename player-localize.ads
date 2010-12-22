

--  Position proxy interface
with Player.Client;
with Player.Interfaces;
with Player.Types;


package Player.Localize is

   pragma Elaborate_Body;

   type Object is new Interfaces.Object with null record;
   --  playerc_localize_t *

   type Hypothesis is record
      Mean   : Pose;
      Cov    : Double_Array (1 .. 3); -- Only diagonal?
      Weight : Double;
   end record;

   type Hypothesis_Array is array (Positive range <>) of Hypothesis;

   procedure Create
     (This  : in out Object;
      Conn  : in     Client.Connection_Type;
      Index : in     Natural := 0);

   function Get_Hypotheses (This : Object) return Hypothesis_Array;

   procedure Subscribe    (This : in out Object; Mode : in Access_Modes);

   procedure Unsubscribe  (This : in out Object);

--     procedure Set_Pose
--       (This : in out Object;
--        Pose : in     Player.Pose;
--        Cov  : in     Covariance);
   --  BROKEN: somehow in player3, covs are 3xdouble instead of 9xdouble ???

private

   procedure Destroy (This : in out Object);

   procedure Destroy_Handle (This : in Types.Handle);
   pragma Import (C, Destroy_Handle, "playerc_localize_destroy");

end Player.Localize;
