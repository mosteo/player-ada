#include <libplayerc/playerc.h>

int main ()
{
  playerc_client_t *client;
  playerc_position2d_t *pos;

  client = playerc_client_create (NULL, "localhost", 6665);
  if (playerc_client_connect (client))
    playerc_error_str();

  pos = playerc_position2d_create (client, 0);
  if (playerc_position2d_subscribe (pos, PLAYER_OPEN_MODE))
    playerc_error_str();

  if (playerc_position2d_set_cmd_vel (pos, 0.1, 0.0, 0.0, 1))
    playerc_error_str();

  while (1)
    {
      if (playerc_client_read (client))
        playerc_error_str();
    }

  return 0;
}
