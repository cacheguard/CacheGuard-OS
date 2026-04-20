#!/bin/bash

############################################################################
#
# MODULE:       Patch
# AUTHOR(S):    Afshin Tajvidi, <afshin.tajvidi(at)cacheguard.com>
# COPYRIGHT:    (C) 2009-2017 by the CacheGuard Technologies Limited
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
###########################################################################

source /etc/sysconfig/cacheguard/constant
source ${ABASE_DIR}/${ENV_RDIR}/${ENV_NAME}

rename-ssh-service()
{
    local service_file=/root/apply-patch/services
    local tmp_service_file=/tmp/services.${$}

    test -f ${service_file} || return 0

    sed -e 's/^ssh$/sshd/' ${service_file} > ${tmp_service_file}
    mv -f ${tmp_service_file} ${service_file}
}

remove-titles-from-user-dashboard()
{
    test -n "${1}" || return 1
    local user=${1}

    local dashboard_file=${BASE_DIR}/${user}/${ENV_RDIR}/${GUI_DASHBOARD_LAYOUT_FILENAME}

    if test ! -f ${dashboard_file} ; then
	touch ${dashboard_file}
	chown ${user}:${GROUP_NAME} ${dashboard_file}
	chmod 664 ${dashboard_file}
	return 0
    fi

    if test ! -s ${dashboard_file} ; then
	chown ${user}:${GROUP_NAME} ${dashboard_file}
	chmod 664 ${dashboard_file}
	return 0
    fi

    local page height left top state title
    local tmp_file=/root/dashboard.${user}.${$}

    while read page height left top state title
    do
	echo ${page} ${height} ${left} ${top} ${state}
    done < ${dashboard_file} > ${tmp_file}

    install -m 664 -o ${user} -g ${GROUP_NAME} ${tmp_file} ${dashboard_file}
    rm -f ${tmp_file}
}

remove-titles-from-all-dashboard()
{
    local user

    for user in ${ADMIN_NAME} ${ADMIN_USER_LIST}
    do
	remove-titles-from-user-dashboard ${user}
    done
}

clear-ssl-cache()
{
    /etc/rc.d/init.d/squid clearssl > /dev/null 2>&1
}

remove-old-qos-index()
{
    rm -f /etc/sysconfig/qos.index
}

supervisor-restart()
{
        /etc/rc.d/init.d/supervisor restart > /dev/null 2>&1
}

main()
{
    rename-ssh-service
    remove-titles-from-all-dashboard
    clear-ssl-cache
    remove-old-qos-index
    supervisor-restart
}

# Main( )

main
