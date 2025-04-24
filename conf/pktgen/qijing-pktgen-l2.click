/* 
 * Multi-core L2 UDP packet generator with parameterized element classes
 *
 * Each core generates traffic independently and sends it using DPDK queues.
 */

// Default values for packet length, number of packets, and replay count
define($L 60, $N 16, $S 100000);

// MAC and IP addresses
define($mymac 10:70:fd:87:0e:ba)
define($dmac 10:70:fd:6b:93:5c)
define($myip 10.0.2.102)
define($dstip 10.0.2.101)

// Verbose and blocking flags
define($verbose 3)
define($blocking true)
define($cores 16) // Number of cores/queues to use

// ###################
// TX: Multi-threaded generation and sending
// ###################

// Parameterized generator element class
elementclass Generator {
    $queue, $sip|
    FastUDPFlows(RATE 0, LIMIT 200, LENGTH $L, SRCETH $mymac, DSTETH $dmac, SRCIP $sip, DSTIP $dstip, FLOWS 1, FLOWSIZE $N)
    //-> MarkMACHeader
    //-> EnsureDPDKBuffer
    -> replay :: MultiReplayUnqueue(STOP -1, ACTIVE false, QUICK_CLONE 1)
    -> ic :: AverageCounter()
    -> ToDPDKDevice(0, QUEUE $queue, BLOCKING $blocking, VERBOSE $verbose);
}

// Instantiate generators for all cores
generator0 :: Generator(0  , 10.0.2.102);
generator1 :: Generator(1  , 10.0.2.103);
generator2 :: Generator(2  , 10.0.2.104);
generator3 :: Generator(3  , 10.0.2.105);
generator4 :: Generator(4  , 10.0.2.106);
generator5 :: Generator(5  , 10.0.2.107);
generator6 :: Generator(6  , 10.0.2.108);
generator7 :: Generator(7  , 10.0.2.109);
generator8 :: Generator(8  , 10.0.2.110);
generator9 :: Generator(9  , 10.0.2.111);
generator10 :: Generator(10, 10.0.2.112);
generator11 :: Generator(11, 10.0.2.113);

// Static thread scheduling
StaticThreadSched(generator0/replay 0, generator1/replay 1, generator2/replay 2, generator3/replay 3, generator4/replay 4, generator5/replay 5, 
generator6/replay 6, generator6/replay 6, generator7/replay 7, generator8/replay 8, generator9/replay 9, generator10/replay 10,  generator11/replay 11);

// ###################
// RX: Optional receiver for monitoring
// ###################
fd :: FromDPDKDevice(0, PROMISC true, VERBOSE $verbose)
-> oc :: AverageCounter()
-> Discard;

// ###################
// Script to control and display stats
// ###################
Script(TYPE ACTIVE,
    wait 5ms,
    write generator0/replay.active true,
    write generator1/replay.active true,
    write generator2/replay.active true,
    write generator3/replay.active true,
    write generator4/replay.active true,
    write generator5/replay.active true,
    write generator6/replay.active true,
    write generator7/replay.active true,
    write generator8/replay.active true,
    write generator9/replay.active true,
    write generator10/replay.active true,
    write generator11/replay.active true,
    label start,
    print "Core 0 TX packets: $(generator0/ic.count), TX rate: $(generator0/ic.link_rate)",
    print "Core 1 TX packets: $(generator1/ic.count), TX rate: $(generator1/ic.link_rate)",
    print "Core 2 TX packets: $(generator2/ic.count), TX rate: $(generator2/ic.link_rate)",
    print "Core 3 TX packets: $(generator3/ic.count), TX rate: $(generator3/ic.link_rate)",
    print "Core 4 TX packets: $(generator4/ic.count), TX rate: $(generator4/ic.link_rate)",
    print "Core 5 TX packets: $(generator5/ic.count), TX rate: $(generator5/ic.link_rate)",
    print "Core 6 TX packets: $(generator6/ic.count), TX rate: $(generator6/ic.link_rate)",
    print "Core 7 TX packets: $(generator7/ic.count), TX rate: $(generator7/ic.link_rate)",
    print "Core 8 TX packets: $(generator8/ic.count), TX rate: $(generator8/ic.link_rate)",
    print "Core 9 TX packets: $(generator9/ic.count), TX rate: $(generator9/ic.link_rate)",
    print "Core 10 TX packets: $(generator10/ic.count), TX rate: $(generator10/ic.link_rate)",
    print "Core 11 TX packets: $(generator11/ic.count), TX rate: $(generator11/ic.link_rate)",
    write generator0/ic.reset,
    write generator1/ic.reset,
    write generator2/ic.reset,
    write generator3/ic.reset,
    write generator4/ic.reset,
    write generator5/ic.reset,
    write generator6/ic.reset,
    write generator7/ic.reset,
    write generator8/ic.reset,
    write generator9/ic.reset,
    write generator10/ic.reset,
    write generator11/ic.reset,
    print "RX packets: $(oc.count), RX rate: $(oc.link_rate)",
    write oc.reset,
    wait 1s,
    goto start
)