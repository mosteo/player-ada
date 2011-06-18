#include "libplayerc/playerc.h"

int
playerc_open_mode ()
{
  return PLAYERC_OPEN_MODE;
}

int
playerc_close_mode ()
{
  return PLAYERC_CLOSE_MODE;
}

int
playerc_error_mode ()
{
  return PLAYERC_ERROR_MODE;
}

int
playerc_device_get_fresh(playerc_device_t *device)
{
  return device->fresh;
}

void
playerc_device_set_fresh(playerc_device_t *device,
                         int fresh)
{
  device->fresh = fresh;
}

int
player_ada_graphics2d_set_color(playerc_graphics2d_t *proxy,
                                 int a, int r, int g, int b)
{
  const player_color_t color = {a, r, g, b};
  return playerc_graphics2d_setcolor(proxy, color);
}

void
player_ada_graphics2d_get_color(playerc_graphics2d_t *proxy,
                                 int *a, int *r, int *g, int *b)
{
    *a = proxy->color.alpha;
    *r = proxy->color.red;
    *g = proxy->color.green;
    *b = proxy->color.blue;
}

void
player_ada_laser_get_geom (playerc_laser_t *proxy,
			   double *x, double *y, double *a)
{
    *x = proxy->pose[0];
    *y = proxy->pose[1];
    *a = proxy->pose[2];
}

void
player_ada_laser_get_size (playerc_laser_t *proxy,
			   double *x, double *y)
{
    *x = proxy->size[0];
    *y = proxy->size[1];
}

int
player_ada_laser_scan_count(playerc_laser_t *proxy)
{
    return proxy->scan_count;
}

double
player_ada_laser_scan_start(playerc_laser_t *proxy)
{
    return proxy->scan_start;
}

double
player_ada_laser_scan_res(playerc_laser_t *proxy)
{
    return proxy->scan_res;
}

double
player_ada_laser_range_res(playerc_laser_t *proxy)
{
    return proxy->range_res;
}

double
player_ada_laser_max_range(playerc_laser_t *proxy)
{
    return proxy->max_range;
}

void
player_ada_laser_get_scan(playerc_laser_t *proxy,
			  int i,
			  double *range, double *bearing,
			  double *x, double *y,
			  int *intensity)
{
    *range     = proxy->ranges[i]; /* proxy->scan[i][0] ??? */
    *bearing   = proxy->scan[i][1];
    *x         = proxy->point[i].px;
    *y         = proxy->point[i].py;
    *intensity = proxy->intensity[i];
}

int
player_ada_laser_get_scan_id(playerc_laser_t *proxy)
{
    return proxy->scan_id;
}

double
player_ada_laser_get_min_right(playerc_laser_t *proxy)
{
    return proxy->min_right;
}

double
player_ada_laser_get_min_left(playerc_laser_t *proxy)
{
    return proxy->min_left;
}

void
player_ada_laser_get_robot_pose(playerc_laser_t *proxy,
				double *x, double *y, double *a)
{
    *x = proxy->robot_pose[0];
    *y = proxy->robot_pose[1];
    *a = proxy->robot_pose[2];
}

int
player_ada_sonar_get_pose_count(playerc_sonar_t *proxy)
{
    return proxy->pose_count;
}

void
player_ada_sonar_get_pose(playerc_sonar_t *proxy,
				int i,
				double *px, double *py, double *pz,
				double *proll, double *ppitch, double *pyaw)
{
    *px = proxy->poses[i].px;
    *py = proxy->poses[i].py;
    *pz = proxy->poses[i].pz;
    *proll = proxy->poses[i].proll;
    *ppitch = proxy->poses[i].ppitch;
    *pyaw = proxy->poses[i].pyaw;
}

int
player_ada_sonar_get_scan_count(playerc_sonar_t *proxy,
				int *ranges_count)
{
    return proxy->scan_count;
}

double
player_ada_sonar_get_scan(playerc_sonar_t *proxy,
				int i)
{
    return proxy->scan[i];
}

void
player_ada_position2d_get_geom(playerc_position2d_t *proxy,
			       double *x, double *y, double *a)
{
    playerc_position2d_get_geom(proxy);
    *x = proxy->pose[0];
    *y = proxy->pose[1];
    *a = proxy->pose[2];
}

void
player_ada_position2d_get_size(playerc_position2d_t *proxy,
			       double *sx, double *sy)
{
    playerc_position2d_get_geom(proxy);
    *sx = proxy->size[0];
    *sy = proxy->size[1];
}

void
player_ada_position2d_get_pose(playerc_position2d_t *proxy,
			       double *x, double *y, double *a)
{
    *x = proxy->px;
    *y = proxy->py;
    *a = proxy->pa;
}

void
player_ada_position2d_get_velo(playerc_position2d_t *proxy,
			       double *x, double *y, double *a)
{
    *x = proxy->vx;
    *y = proxy->vy;
    *a = proxy->va;
}

int
player_ada_position2d_get_stalled(playerc_position2d_t *proxy)
{
    return proxy->stall;
}

int
player_ada_localize_get_hypo_count(playerc_localize_t *proxy)
{
  return proxy->hypoth_count;
}

void
player_ada_localize_get_hypo(playerc_localize_t *proxy,
                             int i, // 0-based
                             double *x, double *y, double *a,
                             double *cx, double *cy, double *ca,
                             double *weight)
{
  *x = proxy->hypoths[i].mean.px;
  *y = proxy->hypoths[i].mean.py;
  *a = proxy->hypoths[i].mean.pa;

  *cx = proxy->hypoths[i].cov[0];
  *cy = proxy->hypoths[i].cov[1];
  *ca = proxy->hypoths[i].cov[2];

  *weight = proxy->hypoths[i].alpha;
}
