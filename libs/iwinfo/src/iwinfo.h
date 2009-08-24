#ifndef __IWINFO_H_
#define __IWINFO_H_

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <glob.h>
#include <ctype.h>
#include <stdint.h>

#include <sys/ioctl.h>
#include <net/if.h>
#include <errno.h>

#include "iwinfo_wl.h"
#include "iwinfo_madwifi.h"
#include "iwinfo_wext.h"


#define IWINFO_BUFSIZE	24 * 1024

struct iwinfo_assoclist_entry {
	uint8_t	mac[6];
	int8_t signal;
	int8_t noise;
};

struct iwinfo_txpwrlist_entry {
	uint8_t	dbm;
	uint8_t	mw;
};

struct iwinfo_crypto_entry {
	uint8_t	enabled;
	uint8_t wpa_version;
	uint8_t group_ciphers;
	uint8_t pair_ciphers;
	uint8_t auth_suites;
};

struct iwinfo_scanlist_entry {
	uint8_t mac[6];
	uint8_t ssid[IW_ESSID_MAX_SIZE+1];
	uint8_t mode[8];
	uint8_t channel;
	uint8_t signal;
	uint8_t quality;
	uint8_t quality_max;
	struct iwinfo_crypto_entry crypto;
};

#endif

