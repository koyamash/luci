/*
 * fwd - OpenWrt firewall daemon - header for rtnetlink communication
 *
 *   Copyright (C) 2009 Jo-Philipp Wich <xm@subsignal.org>
 *
 * The fwd program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License version 2
 * as published by the Free Software Foundation.
 *
 * The fwd program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with the fwd program. If not, see http://www.gnu.org/licenses/.
 */

#ifndef __FWD_ADDR_H__
#define __FWD_ADDR_H__

#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <arpa/inet.h>


struct fwd_addr_list {
	char ifname[IFNAMSIZ];
	char label[IFNAMSIZ];
	int family;
	int index;
	unsigned int prefix;
	union {
		struct in_addr v4;
		struct in6_addr v6;
	} ipaddr;
	struct fwd_addr_list *next;
};


struct fwd_addr_list * fwd_get_addrs(int, int);
struct fwd_addr_list * fwd_append_addrs(struct fwd_addr_list *, struct fwd_addr_list *);
void fwd_free_addrs(struct fwd_addr_list *);

#define fwd_foreach_addrs(head, entry) for(entry = head; entry; entry = entry->next)

#endif

