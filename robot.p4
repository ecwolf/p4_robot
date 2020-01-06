/* -*- P4_16 -*- */

/* BSD 3-Clause License                                                             */
/*                                                                                  */
/* Copyright (c) 2019, Fabricio Rodriguez, UNICAMP, Brazil                          */
/* All rights reserved.                                                             */
/*                                                                                  */
/* Redistribution and use in source and binary forms, with or without               */
/* modification, are permitted provided that the following conditions are met:      */
/*                                                                                  */ 
/* * Redistributions of source code must retain the above copyright notice, this    */
/*   list of conditions and the following disclaimer.                               */
/*                                                                                  */
/* * Redistributions in binary form must reproduce the above copyright notice,      */
/*   this list of conditions and the following disclaimer in the documentation      */
/*   and/or other materials provided with the distribution.                         */
/*                                                                                  */
/* * Neither the name of the copyright holder nor the names of its                  */
/*   contributors may be used to endorse or promote products derived from           */
/*   this software without specific prior written permission.                       */
/*                                                                                  */
/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"      */
/* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE        */
/* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE   */
/* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE     */
/* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL       */
/* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR       */
/* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER       */
/* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,    */
/* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE    */
/* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.             */


#include <core.p4>
#include <v1model.p4>

const bit<16> TYPE_IPV4 = 0x800;
const bit<8> UDP_TYPE = 0x11;
const bit<8> TCP_TYPE = 0x06;

//LEN variables
const bit<16> IPV4_LEN_d = 20;
const bit<16> IPV4_LEN = 16w20;
const bit<32> TCP_val_d = 32;
const bit<32> TCP_IP = 52;

//FIN LEN variables


const bit<16> IPV4_LEN_mod = 56;              // with DATA = 4
const bit<32> IPV4_LEN_mod_2 = 56;            // with DATA = 4
//const bit<16> IPV4_LEN_mod = 81;                // with DATA = 29
//const bit<32> IPV4_LEN_mod_2 = 81;              // with DATA = 29

//const bit<32> TCP_DATA_LEN = 0;
const bit<16> payload_LEN_mod = 16w56;        // with DATA = 4
//const bit<16> payload_LEN_mod = 16w113;         // with DATA = 29
const bit<16> IPV4_LEN_mod_check = 16w36;     // with DATA = 4
//const bit<16> IPV4_LEN_mod_check = 16w61;       // with DATA = 29
//const bit<4> TCP_LEN_modl;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<8> payload_table_start_t;
typedef bit<40> payload_table_match_t;
typedef bit<440> payload_pose;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

header udp_t
{
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> len;
    bit<16> checksum;
    //payload - we only consider 5 bytes of data
    bit<40> payload;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  flags_1;
    bit<3>  flags_2;
    bit<3>  flags_3;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
    bit<96> options;
    //bit<40> payload;
}


header tcp_payload_t {
    bit<8> payload_start;
    bit<40> payload_match;
    //bit<272> payload_end;
}

header tcp_payload_2_t {
    //bit<8> payload_start;
    //bit<40> payload_match;
    bit<272> payload;
}

header tcp_payload_mod_t {
    bit<24> payload;
    //payload_pose payload;
}

header tcp_payload_mod_long_t {
    bit<256> payload;
    //payload_pose payload;
}

struct meta_tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  flags_1;
    bit<3>  flags_2;
    bit<3>  flags_3;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
    bit<96> options;
}

struct meta_ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

struct tcp_metadata_t {
    bit<16> full_length; //ipv4.totalLen - 20
    bit<16> full_length_in_bytes;
    bit<16> header_length;
    bit<16> header_length_in_bytes;
    bit<16> payload_length;
    bit<16> payload_length_in_bytes;
    bit<16> tcp_header_length_for_checksum;
    bit<16> tcp_payload_pose;  //p[
    bit<64> tcp_payload_X;     //X pose e.g., 0.720471
    bit<32> TCP_DATA_LEN;
    bit<32> IP_DATA_LEN;
}

struct tcp_metadata_mod_t {
    bit<16> full_length; //ipv4.totalLen - 20
    bit<16> full_length_in_bytes;
    bit<16> full_length_in_bytes_mod;
    bit<16> header_length;
    bit<16> header_length_in_bytes;
    bit<16> payload_length;
    bit<16> payload_length_in_bytes;
    bit<16> payload_length_in_bytes_2;
    bit<16> tcp_header_length_for_checksum;
}

struct metadata {
    /* empty */
    bit<8>    modified;
    bit<32>  udp_payload_beginning;
    tcp_metadata_t tcp_metadata;
    tcp_metadata_mod_t tcp_metadata_mod;
    meta_tcp_t      meta_tcp;
    meta_ipv4_t     meta_ipv4;
}

struct headers {
    ethernet_t          ethernet;
    ethernet_t          ethernet_copy;
    ipv4_t              ipv4;
    ipv4_t              ipv4_copy;
    udp_t               udp;
    tcp_t               tcp;
    tcp_t               tcp_copy;
    tcp_payload_t       tcp_payload;
    tcp_payload_mod_t   tcp_payload_mod;
    tcp_payload_2_t     tcp_payload_2;
    tcp_payload_mod_long_t tcp_payload_mod_long;
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_IPV4: parse_ipv4;
            default: accept;
        }
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            UDP_TYPE : parse_udp;
            TCP_TYPE : parse_tcp;
            default : accept;
        }
    }

    state parse_udp {
        packet.extract(hdr.udp);
        //meta.udp_payload_beginning = hdr.udp.payload[127:96];
        transition accept;

    }

    state parse_tcp {
        packet.extract(hdr.tcp);

        //FOR TCP
        meta.tcp_metadata.full_length = (hdr.ipv4.totalLen - IPV4_LEN) * 8;
        meta.tcp_metadata.header_length = (((bit<16>)hdr.tcp.dataOffset) << 5);
        meta.tcp_metadata.payload_length = meta.tcp_metadata.full_length - meta.tcp_metadata.header_length;
        meta.tcp_metadata.full_length_in_bytes =  (hdr.ipv4.totalLen - IPV4_LEN);
        meta.tcp_metadata.header_length_in_bytes = (bit<16>)hdr.tcp.dataOffset << 2;
        meta.tcp_metadata.payload_length_in_bytes = (hdr.ipv4.totalLen - IPV4_LEN) - ((bit<16>)hdr.tcp.dataOffset << 2);
        meta.tcp_metadata.tcp_header_length_for_checksum = meta.tcp_metadata.header_length_in_bytes + meta.tcp_metadata.payload_length_in_bytes;

        meta.tcp_metadata.TCP_DATA_LEN = (((bit<32>)meta.tcp_metadata.full_length_in_bytes)) - TCP_IP;


        //testing

        //meta.tcp_metadata_mod.full_length_in_bytes_mod = (hdr.ipv4.totalLen - payload_LEN_mod);
        //meta.tcp_metadata_mod.full_length_in_bytes =  (meta.tcp_metadata_mod.full_length_in_bytes_mod - IPV4_LEN);
        //meta.tcp_metadata_mod.header_length_in_bytes = (bit<16>)hdr.tcp.dataOffset << 2;
        //meta.tcp_metadata_mod.payload_length_in_bytes = (hdr.ipv4.totalLen - IPV4_LEN) - ((bit<16>)hdr.tcp.dataOffset << 2);

        //meta.tcp_metadata_mod.tcp_header_length_for_checksum = payload_LEN_mod;

        //

        //meta.tcp_metadata.tcp_payload_pose = hdr.tcp_payload.payload[455:440];
        //meta.tcp_metadata.tcp_payload_X = hdr.tcp_payload.payload[295:232];


//        meta.tcp_metadata.full_length_in_bytes =  hdr.ipv4.totalLen - (((bit<16>)hdr.ipv4.ihl) << 2);//(hdr.ipv4.totalLen - IPV4_LEN);
  //      meta.tcp_metadata.header_length_in_bytes = (bit<16>)hdr.tcp.dataOffset << 2;
      //  meta.tcp_metadata.payload_length_in_bytes = (hdr.ipv4.totalLen - IPV4_LEN) - ((bit<16>)hdr.tcp.dataOffset << 2);
    //    meta.tcp_metadata.tcp_header_length_for_checksum = meta.tcp_metadata.header_length_in_bytes + meta.tcp_metadata.payload_length_in_bytes;
        transition parse_tcp_payload;

    }

    state parse_tcp_payload {
        packet.extract(hdr.tcp_payload);
        transition parse_tcp_payload_2;

    }

    state parse_tcp_payload_2 {
        packet.extract(hdr.tcp_payload_2);
        transition accept;

    }



}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {   
    apply {  }
}

extern Register<T> {
    Register(bit<32> size);
    T read(bit<32> index);
    void write(bit<32> index, T value);
}

/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    action drop() {
        mark_to_drop();
    }
    
    action ipv4_forward(macAddr_t dstAddr, egressSpec_t port) {
        clone3(CloneType.I2E, 0, {  });
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
        hdr.ipv4.identification = 0;

    }
    
    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }


    //UDP

    action udp_forward_hack() {
        hdr.udp.payload = 0x736963630a; // payload='sicc'
        //hdr.udp.payload[127:96] = 0x73696363; // payload='sicc' + rest of the payload
        meta.modified = 0x1;

    }

    table udp_exact {
        key = { 
            hdr.udp.payload : exact;  //match just cica
            //matching on substring is not really liked by the P4 compiler
            //meta.udp_payload_beginning: exact;  // match the cica at the, and later add the rest of the payload
        }

        actions = {
            udp_forward_hack;
            NoAction;
        }

        default_action = NoAction;

        const entries = {
            0x636963610a : udp_forward_hack(); // match for cica
            //0x63696361 : udp_forward_hack(); // match for cica +++++
        }
    }


    //TCP

    action tcp_forward_hack(payload_table_start_t payload_start, payload_table_match_t payload_match, bit<9> port) {
        //hdr.tcp_payload.payload = payload; // payload='s['
        //hdr.tcp_payload_mod.payload = payload;
        //hdr.tcp_payload.payload = payload; // payload='sicc'
        //hdr.tcp_payload.payload = 0x736963630a; // payload='sicc'
        //hdr.udp.payload[127:96] = 0x73696363; // payload='sicc' + rest of the payload
        

        //hdr.tcp.dataOffset = TCP_LEN_mod;


        //Add new payload

        //Removing the old headers
        hdr.ethernet.setInvalid();
        hdr.ipv4.setInvalid();
        hdr.tcp.setInvalid();
        //hdr.tcp_payload.setInvalid();
        //hdr.tcp_payload_2.setInvalid();
        
        //Updating ethernet
        hdr.ethernet_copy.setValid();
        hdr.ethernet_copy.dstAddr = hdr.ethernet.srcAddr;               // Updated with srcaddr          
        hdr.ethernet_copy.srcAddr = hdr.ethernet.dstAddr;               // Updated with dstaddr
        hdr.ethernet_copy.etherType = hdr.ethernet.etherType;           

        //Updating IPv4
        hdr.ipv4_copy.setValid();
        hdr.ipv4_copy.version = hdr.ipv4.version;
        hdr.ipv4_copy.ihl = hdr.ipv4.ihl;
        hdr.ipv4_copy.diffserv = hdr.ipv4.diffserv;
        //hdr.ipv4_copy.totalLen = IPV4_LEN_mod;                         // New IPv4 len
        hdr.ipv4_copy.totalLen = hdr.ipv4.totalLen;                         // New IPv4 len for gen size
        hdr.ipv4_copy.identification = hdr.ipv4.identification;        // Can be set as 0
        hdr.ipv4_copy.flags = hdr.ipv4.flags;
        hdr.ipv4_copy.fragOffset = hdr.ipv4.fragOffset;
        hdr.ipv4_copy.ttl = hdr.ipv4.ttl+1;                         
        hdr.ipv4_copy.protocol = hdr.ipv4.protocol;
        hdr.ipv4_copy.hdrChecksum = hdr.ipv4.hdrChecksum;              // Will be recalculated
        hdr.ipv4_copy.srcAddr = hdr.ipv4.dstAddr;                      // Updated with dstaddr
        hdr.ipv4_copy.dstAddr = hdr.ipv4.srcAddr;                      // Updated with srcaddr

        //Updating TCP
        hdr.tcp_copy.setValid();
        hdr.tcp_copy.srcPort = hdr.tcp.dstPort;                        // Updated with dstPort
        hdr.tcp_copy.dstPort = hdr.tcp.srcPort;                        // Updated with srcPort
        hdr.tcp_copy.seqNo = hdr.tcp.ackNo;                            // Updated with ACK Robot-Controller
        hdr.tcp_copy.ackNo = hdr.tcp.seqNo + meta.tcp_metadata.TCP_DATA_LEN;             // Updated with SEQ (ROBOT-CONTROLLER) + TCP_DATA_LEN (IPv4_TOTAL_LEN - TCP_LEN - IP_LEN)
        hdr.tcp_copy.dataOffset = hdr.tcp.dataOffset;
        hdr.tcp_copy.res = hdr.tcp.res;
        hdr.tcp_copy.flags_1 = hdr.tcp.flags_1;
        hdr.tcp_copy.flags_2 = hdr.tcp.flags_2;
        hdr.tcp_copy.flags_3 = hdr.tcp.flags_3;
        hdr.tcp_copy.window = hdr.tcp.window;       
        hdr.tcp_copy.checksum = hdr.tcp.checksum;                       // Will be recalculated
        hdr.tcp_copy.urgentPtr = hdr.tcp.urgentPtr;
        hdr.tcp_copy.options = hdr.tcp.options;

        //New payload
        //hdr.tcp_payload_mod.setValid();
        //hdr.tcp_payload_mod.payload = payload;   // New Payload 28 30 29  (0)
        
        hdr.tcp_payload.payload_start = payload_start;     // (
        hdr.tcp_payload.payload_match = payload_match;     // 0)000
        
        //meta.tcp_metadata.payload_length_in_bytes_2=meta.tcp_metadata.payload_length_in_bytes + 7;
        //hdr.tcp_payload_2.payload[meta.tcp_metadata.payload_length_in_bytes_2:meta.tcp_metadata.payload_length_in_bytes] = payload_end;

        //hdr.tcp_payload_mod_long.setValid();
        //hdr.tcp_payload_mod_long.payload[255:232] = payload;         // New Payload 28 30 29  (0)

        // Set the metadata to 1 to mark the pkt to recalculate checksum
        meta.modified = 0x1;

        // Update egress_port
        standard_metadata.egress_spec = port;
    }


    //action tcp_forward_2 (payload_table_t payload) {
        //hdr.tcp_payload.payload = payload; // payload='s['
        //hdr.tcp_payload_mod.payload = payload;
        //hdr.tcp_payload.payload = payload; // payload='sicc'
        
        //hdr.tcp.setValid();
        //hdr.tcp_payload.setInvalid();
        //hdr.tcp_payload_2.setInvalid();
        //hdr.tcp_payload_mod.setValid();

        //hdr.tcp_payload_mod.payload = payload; // payload='sicc'
        //meta.modified = 0x1;
        //hdr.ipv4.totalLen = IPV4_LEN_mod;
        //hdr.ipv4.identification = hdr.ipv4.identification + 2;
        //}

    table tcp_exact {
        key = { 
            hdr.tcp_payload.payload_match : exact;  //match  for 2.063
            //matching on substring is not really liked by the P4 compiler
            //meta.udp_payload_beginning: exact;  // match the cica at the, and later add the rest of the payload
        }

        actions = {
            tcp_forward_hack;
            //tcp_forward_2;
            NoAction;
        }
        size = 1024;
        default_action = NoAction;

        //const entries = {
            //0x636963610a : tcp_forward_hack(); // match for cica
            //0x63696361 : udp_forward_hack(); // match for cica +++++
        //}
    }


    
    apply {
        if (hdr.ipv4.isValid()) {
            ipv4_lpm.apply();
        }
        if (hdr.udp.isValid()) {
            udp_exact.apply();
        }
        if (hdr.tcp.isValid()) {
            tcp_exact.apply();
        }
    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    

    /*action update_port(bit<9> port) {
        standard_metadata.egress_spec = port;
    }
    action drop() {
        mark_to_drop();
    }
    table port_match {
        key = {
            meta.modified: exact;
        }
        actions = {
            update_port;
            NoAction;
            drop;
        }
        size = 256;
    }
    apply {
        port_match.apply();
    }*/

    
    action ipv4_eforward(macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
        hdr.ipv4.identification = 0;
        meta.modified = 0x0;
    }
    
    action drop() {
        mark_to_drop();
    }

    table ipv4_elpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_eforward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

    apply { 
        ipv4_elpm.apply();
    }

}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {
	//Normal IP
    update_checksum(
        (hdr.ipv4.isValid() && meta.modified == 0x0),
            { hdr.ipv4.version,
              hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);

    //NEW IP
    update_checksum(
	    (hdr.ipv4_copy.isValid() && meta.modified == 0x1),
            { hdr.ipv4_copy.version,
	          hdr.ipv4_copy.ihl,
              hdr.ipv4_copy.diffserv,
              hdr.ipv4_copy.totalLen,
              //payload_LEN_mod,
              hdr.ipv4_copy.identification,
              hdr.ipv4_copy.flags,
              hdr.ipv4_copy.fragOffset,
              hdr.ipv4_copy.ttl,
              hdr.ipv4_copy.protocol,
              hdr.ipv4_copy.srcAddr,
              hdr.ipv4_copy.dstAddr },
              hdr.ipv4_copy.hdrChecksum,
            HashAlgorithm.csum16);

    
    //UDP header checksum
    update_checksum(
        (hdr.udp.isValid() && meta.modified == 0x1),
        {   hdr.ipv4.srcAddr,
            hdr.ipv4.dstAddr,
            8w0,
            hdr.ipv4.protocol,
            hdr.udp.len,
            hdr.udp.srcPort,
            hdr.udp.dstPort,
            hdr.udp.len,
            hdr.udp.payload
            },
           hdr.udp.checksum,
           HashAlgorithm.csum16);

    //TCP header checksum
    update_checksum_with_payload(
        (hdr.tcp_copy.isValid() && hdr.ipv4_copy.protocol == TCP_TYPE && meta.modified == 0x1),
        {   hdr.ipv4_copy.srcAddr,
            hdr.ipv4_copy.dstAddr,
            8w0,
            hdr.ipv4_copy.protocol,
            meta.tcp_metadata.tcp_header_length_for_checksum,
            hdr.tcp_copy.srcPort,
            hdr.tcp_copy.dstPort,
            hdr.tcp_copy.seqNo,
            hdr.tcp_copy.ackNo,
            hdr.tcp_copy.dataOffset,
            hdr.tcp_copy.res,
            hdr.tcp_copy.flags_1,
            hdr.tcp_copy.flags_2,
            hdr.tcp_copy.flags_3,
            hdr.tcp_copy.window,
            hdr.tcp_copy.urgentPtr,
            hdr.tcp_copy.options,
            hdr.tcp_payload.payload_start,
            hdr.tcp_payload.payload_match,
            hdr.tcp_payload_2.payload
            },
          hdr.tcp_copy.checksum,
          HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.udp);
        packet.emit(hdr.tcp);
        packet.emit(hdr.ethernet_copy);
        packet.emit(hdr.ipv4_copy);
        packet.emit(hdr.tcp_copy);
        packet.emit(hdr.tcp_payload);     
        packet.emit(hdr.tcp_payload_2);   
        //packet.emit(hdr.tcp_payload_mod);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;


