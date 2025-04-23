/* 
 * Multi-core L2 packet receiver with parameterized element classes
 *
 * Each core processes packets independently using separate DPDK queues.
 */

// MAC and IP addresses
define($mymac 10:70:fd:6b:93:5c)
define($dmac 10:70:fd:87:0e:ba)
define($myip 10.0.2.101)
define($dstip 10.0.1.102)

// Verbose and blocking flags
define($verbose 3)
define($blocking true)
define($cores 16) // Number of cores/queues to use

// ###################
// RX: Multi-threaded receiving and processing
// ###################

// Parameterized receiver element class
elementclass Receiver {
    $queue |
    FromDPDKDevice(2, QUEUE $queue, PROMISC true, VERBOSE $verbose)
    -> oc :: AverageCounter()
    -> EtherMirror
    -> ic :: AverageCounter()
    -> ToDPDKDevice(2, QUEUE $queue, BLOCKING $blocking, VERBOSE $verbose);
}

// Instantiate receivers for all cores
receiver0 :: Receiver(0);
receiver1 :: Receiver(1);
receiver2 :: Receiver(2);
receiver3 :: Receiver(3);
receiver4 :: Receiver(4);
receiver5 :: Receiver(5);
receiver6 :: Receiver(6);
receiver7 :: Receiver(7);
// receiver8 :: Receiver(8);
// receiver9 :: Receiver(9);
// receiver10 :: Receiver(10);
// receiver11 :: Receiver(11);
// receiver12 :: Receiver(12);
// receiver13 :: Receiver(13);
// receiver14 :: Receiver(14);
// receiver15 :: Receiver(15);

// Static thread scheduling
StaticThreadSched(
    receiver0 8, receiver1 9, receiver2 10, receiver3 11,
    receiver4 12, receiver5 13, receiver6 14, receiver7 15,
   // receiver8 24, receiver9 25, receiver10 26, receiver11 27,
   // receiver12 28, receiver13 29, receiver14 30, receiver15 31
);

// ###################
// Script to display stats
// ###################
Script(TYPE ACTIVE,
    label start,
    wait 1s,
    print "Core 0 RX packets: $(receiver0/oc.count), RX rate: $(receiver0/oc.link_rate), TX packets: $(receiver0/ic.count), TX rate: $(receiver0/ic.link_rate)",
    print "Core 1 RX packets: $(receiver1/oc.count), RX rate: $(receiver1/oc.link_rate), TX packets: $(receiver1/ic.count), TX rate: $(receiver1/ic.link_rate)",
    print "Core 2 RX packets: $(receiver2/oc.count), RX rate: $(receiver2/oc.link_rate), TX packets: $(receiver2/ic.count), TX rate: $(receiver2/ic.link_rate)",
    print "Core 3 RX packets: $(receiver3/oc.count), RX rate: $(receiver3/oc.link_rate), TX packets: $(receiver3/ic.count), TX rate: $(receiver3/ic.link_rate)",
    print "Core 4 RX packets: $(receiver4/oc.count), RX rate: $(receiver4/oc.link_rate), TX packets: $(receiver4/ic.count), TX rate: $(receiver4/ic.link_rate)",
    print "Core 5 RX packets: $(receiver5/oc.count), RX rate: $(receiver5/oc.link_rate), TX packets: $(receiver5/ic.count), TX rate: $(receiver5/ic.link_rate)",
    print "Core 6 RX packets: $(receiver6/oc.count), RX rate: $(receiver6/oc.link_rate), TX packets: $(receiver6/ic.count), TX rate: $(receiver6/ic.link_rate)",
    print "Core 7 RX packets: $(receiver7/oc.count), RX rate: $(receiver7/oc.link_rate), TX packets: $(receiver7/ic.count), TX rate: $(receiver7/ic.link_rate)",
    // print "Core 8 RX packets: $(receiver8/oc.count), RX rate: $(receiver8/oc.link_rate), TX packets: $(receiver8/ic.count), TX rate: $(receiver8/ic.link_rate)",
    // print "Core 9 RX packets: $(receiver9/oc.count), RX rate: $(receiver9/oc.link_rate), TX packets: $(receiver9/ic.count), TX rate: $(receiver9/ic.link_rate)",
    // print "Core 10 RX packets: $(receiver10/oc.count), RX rate: $(receiver10/oc.link_rate), TX packets: $(receiver10/ic.count), TX rate: $(receiver10/ic.// link_rate)",
    // print "Core 11 RX packets: $(receiver11/oc.count), RX rate: $(receiver11/oc.link_rate), TX packets: $(receiver11/ic.count), TX rate: $(receiver11/ic.// link_rate)",
    // print "Core 12 RX packets: $(receiver12/oc.count), RX rate: $(receiver12/oc.link_rate), TX packets: $(receiver12/ic.count), TX rate: $(receiver12/ic.// link_rate)",
    // print "Core 13 RX packets: $(receiver13/oc.count), RX rate: $(receiver13/oc.link_rate), TX packets: $(receiver13/ic.count), TX rate: $(receiver13/ic.// link_rate)",
    // print "Core 14 RX packets: $(receiver14/oc.count), RX rate: $(receiver14/oc.link_rate), TX packets: $(receiver14/ic.count), TX rate: $(receiver14/ic.// link_rate)",
    // print "Core 15 RX packets: $(receiver15/oc.count), RX rate: $(receiver15/oc.link_rate), TX packets: $(receiver15/ic.count), TX rate: $(receiver15/ic.// link_rate)",
    write receiver0/oc.reset, write receiver0/ic.reset,
    write receiver1/oc.reset, write receiver1/ic.reset,
    write receiver2/oc.reset, write receiver2/ic.reset,
    write receiver3/oc.reset, write receiver3/ic.reset,
    write receiver4/oc.reset, write receiver4/ic.reset,
    write receiver5/oc.reset, write receiver5/ic.reset,
    write receiver6/oc.reset, write receiver6/ic.reset,
    write receiver7/oc.reset, write receiver7/ic.reset,
   // write receiver8/oc.reset, write receiver8/ic.reset,
   // write receiver9/oc.reset, write receiver9/ic.reset,
   // write receiver10/oc.reset, write receiver10/ic.reset,
   // write receiver11/oc.reset, write receiver11/ic.reset,
   // write receiver12/oc.reset, write receiver12/ic.reset,
   // write receiver13/oc.reset, write receiver13/ic.reset,
   // write receiver14/oc.reset, write receiver14/ic.reset,
   // write receiver15/oc.reset, write receiver15/ic.reset,
    goto start
)



