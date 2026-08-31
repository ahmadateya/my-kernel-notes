## L886
This is the most important struct in the kernel network stack, this is the packet itself


## RX (receive)
```ascii
IRQ from the card
  → driver ISR → napi_schedule()
  → NET_RX_SOFTIRQ
  → net_rx_action()            [net/core/dev.c]
  → napi->poll()               [driver code]
      build_skb() / napi_alloc_skb()
      eth_type_trans()
  → napi_gro_receive()
  → netif_receive_skb()
  → __netif_receive_skb_core()  ← demux is here
  → ip_rcv()                    [net/ipv4/ip_input.c]
      NF_INET_PRE_ROUTING
  → ip_rcv_finish()
      ip_route_input_noref()    ← routing decisions
  → dst_input()                 ← indirect call
      ├─ ip_local_deliver()  → NF_INET_LOCAL_IN
      │    → ip_protocol_deliver_rcu()
      │    → tcp_v4_rcv()       [net/ipv4/tcp_ipv4.c]
      │        __inet_lookup_skb()   ← socket
      │        tcp_v4_do_rcv()
      │        tcp_rcv_established() [tcp_input.c]
      │        tcp_data_queue()
      │        → sk->sk_receive_queue
      │        → sk_data_ready()     ← wake up the process
      └─ ip_forward()          → NF_INET_FORWARD

from the userspace (different thread):
recvmsg() → sock_recvmsg() → inet_recvmsg() → tcp_recvmsg()

```

## TX (transmit)

```ascii
send() / sendmsg()             [net/socket.c]
  → sock_sendmsg() → inet_sendmsg()
  → tcp_sendmsg_locked()       [net/ipv4/tcp.c]
  → tcp_push() → tcp_write_xmit()  [tcp_output.c]
  → tcp_transmit_skb()  ← TCP header building
  → __ip_queue_xmit()          [net/ipv4/ip_output.c]
      sk_dst_cache or route lookup
  → ip_local_out() → NF_INET_LOCAL_OUT
  → dst_output() → ip_output()
      NF_INET_POST_ROUTING
  → ip_finish_output() → ip_finish_output2()
      ip_neigh_for_gw() 
  → neigh_output() ← Ethernet header building
  → dev_queue_xmit()           [net/core/dev.c]
      __dev_xmit_skb() → qdisc
      sch_direct_xmit()
  → dev_hard_start_xmit()
  → ndo_start_xmit()           ← the driver code
```