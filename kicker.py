#!/usr/bin/python

import re
import sys
import os, os.path
import ConfigParser

try:
    from Cheetah.Template import Template
except ImportError:
    print >>sys.stderr, 'ERROR: kicker requires Cheetah templates'
    sys.exit(1)

try:
    import argparse
except ImportError:
    print >>sys.stderr, 'ERROR: kicker requires argparse'
    sys.exit(1)

VERSION = "0.0.4"
CONFIG_FILE = "/home/curtis/working/kicker/kicker.conf"

def main(args):
    
    #Much of the argparse/configparser parts taken from 
    #http://blog.vwelch.com/2011/04/combining-configparser-and-argparse.html

    conf_parser = argparse.ArgumentParser(
        # Turn off help, so we print all options in response to -h
        add_help=False
    )

    conf_parser.add_argument(
        "-c", "--config-file", 
        dest="configfile", 
        help="Use a different config file than %s" % CONFIG_FILE
    )

    args, remaining_argv = conf_parser.parse_known_args()

    if args.configfile:
        configfile = args.configfile
    else:
        configfile = CONFIG_FILE

    # Make sure the configfile is a file
    if not os.path.isfile(configfile):
        print >>sys.stderr, 'ERROR: %s is not a file' % configfile
        sys.exit(1)

    config = ConfigParser.SafeConfigParser()
    try:
        config.read([configfile])
    except:
        print >>sys.stderr, 'ERROR: There is an error in the config file'
        sys.exit(1)

    defaults = dict(config.items("default"))

    parser = argparse.ArgumentParser(
        # Inherit options from config_parser
        parents=[conf_parser],
        # print script description with -h/--help
        description=__doc__,
        # Don't mess with format of description
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.set_defaults(**defaults)

    # Now that we've dealt with getting defaults from a config file we can
    # continue on adding arguments.
    parser.add_argument(
        "-i", "--ipaddress", 
        dest="ipaddress", 
        help="Set the ip address for the host in the kickstart",
    )
    parser.add_argument(
        "-g", "--gateway", 
        dest="gateway", 
        help="Set the gateway for the new host in the kickstart"
    )
    parser.add_argument(
        "-n", "--netmask", 
        dest="netmask", 
        help="Set the netmask for the new host in the kickstart"
    )
    parser.add_argument(
        "-m", "--mode", 
        dest="mode", 
        help="Set a mode, eg. domU_kvm or dom0"
    )
    parser.add_argument(
        "-o", "--os", 
        dest="os", 
        help="What os to create a kickstart for, eg. rhel5 or rhel6"
    )
    parser.add_argument(
        "-k", "--key", 
        dest="key", 
        help="If you have a Redhat install key number"
    )
    parser.add_argument(
        "-r", "--rootpw", 
        dest="rootpw", help="Hashed root password"
    )
    parser.add_argument(
        "-t", "--timezone", 
        dest="timezone",
        help="Timezone in 'American/Edmonton' format"
    )
    parser.add_argument(
        "-d", "--nameservers", 
        dest="nameservers", 
        help="Nameservers in appropriate kickstart format"
    )
    parser.add_argument(
        "--hostname", 
        dest="hostname", 
        help="Set the hostname for the new host in the kickstart"
    )
    parser.add_argument(
        "-p", "--template-dir", 
        dest="templatedir", 
        help="Directory where the kickstart template files are located"
    )

    # Capture args
    args = parser.parse_args(remaining_argv)

    # Makes args into a dictionary to feed to searchList
    d = args.__dict__

    # Change to template dir
    pwd = os.getcwd()
    try:
        os.chdir(args.templatedir)
    except:
        print >>sys.stderr, \
        'ERROR: Template path %s is not a directory' % templatedir
        sys.exit(1)

    # Create template object
    # - the searchList=[d] is the best!
    t = Template(file=args.main_template, searchList=[d])

    print(t.respond())
    
if __name__ == '__main__':
    main(sys.argv)
