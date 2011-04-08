#include "header.tpl"
#include "disk.tpl"

%packages --nobase
#include "packages_common.tpl"
#if $mode == 'dom0'
#include "packages_dom0.tpl"
#end if

%post
#include "post_common.tpl"
#if $mode == 'dom0'
#include "post_dom0.tpl"
#else if $mode == 'domU'
#include "post_domU.tpl"
#else
#include "post_baremetal.tpl"
#end if
