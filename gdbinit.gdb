target remote :1234 

set $virtual_base = 0xffff888000000000
set $vmemmap_base = 0xffffea0000000000

define v2p
set $ans=($arg0-$virtual_base)/0x40+$vmemmap_base
printf "$ans = 0x%lx \n", $ans
end

define p2v
set $ans=($arg0-$vmemmap_base)*0x40+$virtual_base
printf "$ans = 0x%lx \n", $ans
end

set $mod_base = 0xffffffffc0201000

# dprintf *($mod_base + 0x000184),"mod::kmalloc_trace(0x%lx, 0x%lx, 0x%lx)\n",$rdi, $rsi, $rdx
dprintf *($mod_base + 0x000189),"mod::kmalloc ret => 0x%lx\n",$rax
# dprintf *0xffffffff8145145e,"copy_page_from_iter(0x%lx, 0x%lx, 0x%lx, 0x%lx)\n",$rdi, $rsi, $rdx, $rcx
# dprintf *0xffffffff8145145e,"pipe_write::copy_page_from_iter(0x%lx, 0x%lx, 0x%lx, 0x%lx)\n",$rdi, $rsi, $rdx, $rcx
# dprintf *0xffffffff81452038,"alloc_pipe_info::__kmalloc(0x%lx, 0x%lx, 0x%lx, 0x%lx)\n",$rdi, $rsi, $rdx, $rcx
# dprintf *0xffffffff8145203d,"alloc_pipe_info::__kmalloc ret => 0x%lx\n",$rax
# dprintf *0xffffffff81452f9f,"pipe_resize_ring::__kmalloc(0x%lx, 0x%lx, 0x%lx, 0x%lx)\n",$rdi, $rsi, $rdx, $rcx
# dprintf *0xffffffff81452fa4,"pipe_resize_ring::__kmalloc ret => 0x%lx\n",$rax

dprintf *($mod_base + 0x000189),""
commands 
set $aa = $rax
end

define vv
set $tmp = *(long long *)$aa
p/x $tmp
p2v $tmp
tel $ans 10
set $tmp = *(long long *)$ans
p/x $tmp
p2v $tmp
tel $ans 10
end

# b *0x46B330
c