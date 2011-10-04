#!/usr/bin/python

import re
import sys
import os, os.path
from Cheetah.Template import Template
import ConfigParser
from optparse import OptionParser

VERSION = "0.0.3"
CONFIG_FILE = "/home/curtis/working/kicker/kicker.conf"
         
def main(args):
    parser = OptionParser(conflict_handler="resolve")
    parser.add_option("-i", "--ipaddress", dest="ipaddress")
    parser.add_option("-g", "--gateway", dest="gateway")
    parser.add_option("-n", "--netmask", dest="netmask")
    parser.add_option("-m", "--mode", dest="mode")
    parser.add_option("-f", "--filesystem", dest="fs")
    parser.add_option("-m", "--os", dest="os")
    parser.add_option("-k", "--key", dest="key")
    parser.add_option("-r", "--rootpw", dest="rootpw", help="Hashed root password, if not set, rootpw is 'kicker''")
    parser.add_option("-t", "--timezone", dest="timezone", help="Timezone in 'American/Edmonton' format")
    parser.add_option("-d", "--nameservers", dest="nameservers", help="nameservers in appropriate kickstart format")
    parser.add_option("-h", "--hostname", dest="hostname")
    parser.add_option("-p", "--template-dir", dest="templatedir")
    (opts, args) = parser.parse_args()

    # From config file
    conf = ConfigParser.ConfigParser()
    conf.read(CONFIG_FILE)

    main_template = conf.get('default', 'main_template')
    if not opts.templatedir:
        templatedir = conf.get('default', 'templatedir')
    
    # Change to template dir
    pwd = os.getcwd()
    os.chdir(templatedir)
            
    t = Template(file=main_template)

    #
    # networking
    # 
    
    # If no IP address set, don't configure networking
    if opts.ipaddress:
        t.ipaddress = opts.ipaddress
        t.has_ipaddress = True
    
        if opts.gateway:
            t.gateway = opts.gateway
        else:
            # split up ip, do a.b.c.1 for gw
            # FIXME XXX
            t.gateway = 'fix me!'
     
        if opts.netmask:
            t.netmask = opts.netmask
        else:
            t.netmask = conf.get('default', 'netmask')
            
        if opts.nameservers:
            t.nameservers = opts.nameservers
            t.has_nameservers = True
        else:
            t.has_nameservers = False
    else:
        t.has_ipaddress = False
        t.has_nameservers = False
    
    #
    # operating System
    #
    if opts.os:
        t.os = opts.os
    else:
        t.os = conf.get('default', 'os')

    #
    # file system
    #
    if opts.fs:
        t.fs_type = opts.fs
    else:
        if t.os == 'rhel6':
            t.fs_type = 'ext4'
        elif t.os == 'rhel5':
            t.fs_type = 'ext3'
        else:
            t.fs_type = conf.get('default', 'fs')

    #
    # other config
    # 
    t.has_license_key = True
    
    if opts.mode:
        # Should check to see if it's an available mode
        t.mode = opts.mode
    else:
        t.mode = conf.get('default', 'mode')
    
    #
    # keys
    # 
    if opts.key:
        t.key = opts.key
    else:
        try:
            t.key = conf.get('default', 'key')
        except:
            t.has_license_key = False
 
    #
    # password
    #        
    if opts.rootpw:
        t.rootpw = opts.rootpw
        t.isencrypted = True
    else:
        t.rootpw = conf.get('password', 'rootpw')
        t.isencrypted = conf.get('password', 'isencrypted')
   
    #
    # timezone
    #     
    if opts.timezone:
        t.timezone = opts.timezone
    else:
        t.timezone = conf.get('default', 'timezone')

    #
    # hostname
    #
    if opts.hostname:
        t.hostname = opts.hostname
    else:
        t.hostname = conf.get('default', 'hostname')

    #
    # disk and volume names
    #
    if t.mode == 'domU_xen':
        t.disk_type = conf.get('disk', 'default_domU_xen')
        t.system_vg_name = conf.get('volume_name', 'default_domU')
    elif t.mode == 'domU_kvm':
        # for some reason on rhel6 kvm dom0 the rhel6 domU disk is sda
        if t.os == 'rhel6':
            t.disk_type = conf.get('disk', 'default_domU_kvm_rhel6')    
        else:  
            t.disk_type = conf.get('disk', 'default_domU_kvm')
        
        t.system_vg_name = conf.get('volume_name', 'default_domU')
    elif t.mode == "baremetal":
        t.disk_type = conf.get('disk', 'default_baremetal')
        t.system_vg_name = conf.get('volume_name', 'default_baremetal')
    elif t.mode == "dom0":
        t.disk_type = conf.get('disk', 'default_dom0')
        t.system_vg_name = conf.get('volume_name', 'default_dom0')
    else:
        print >> sys.stderr, "Error: mode must be set to [domU_xen|domU_kvm|dom0|baremetal]"
        sys.exit(1)
         
    print(t.respond())
    os.chdir(pwd)
    sys.exit(0)
    
if __name__ == '__main__':
    main(sys.argv)
