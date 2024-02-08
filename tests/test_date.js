pass=0;

try { new Date(4.1e16); pass--; } catch(e) { };
try { new Date(-4.1e16); pass--; } catch(e) { };
try { new Date(2000000,0); pass--; } catch(e) { };
try { new Date(-2000000,0); pass--; } catch(e) { };
// This next Date() constructor use to give a segfault. However it is now out of range for the PICO_R1_3
try { a = new Date(-12,8).toString(); if (!(a== "Wed Aug 31 -12 00:00:00 GMT+0000")) pass--; } catch (e) { };

var gmt = [
[ Date.parse("2011-10-20") , 1319068800000.0 ],
[ Date.parse("2011-10-20T14:48:12.345") , 1319122092345.0 ],
[ Date.parse("Aug 9, 1995") , 807926400000.0 ],
[ new Date("Wed, 09 Aug 1995 00:00:00").getTime() , 807926400000.0 ],
[ Date.parse("Thu, 01 Jan 1970 00:00:00 GMT") , 0.0 ],
[ Date.parse("Thu, 01 Jan 1970 00:00:00 GMT-0100") , 3600000.0 ],
[ Date.parse("Mon, 25 Dec 1995 13:30:00 +0430"), 819882000000.0 ],
[ new Date(807926400000.0).toString() , "Wed Aug 9 1995 00:00:00 GMT+0000" ],
[ new Date("Fri, 20 Jun 2014 15:27:22 GMT").toString(), "Fri Jun 20 2014 15:27:22 GMT+0000"],
[ new Date("Fri, 20 Jun 2014 15:27:22 GMT").toISOString(), "2014-06-20T15:27:22.000Z"],
[ new Date("Fri, 20 Jun 2014 17:27:22 GMT+0200").toISOString(), "2014-06-20T15:27:22.000Z"],
[ new Date("5000-1-1").toString(), "Wed Jan 1 5000 00:00:00 GMT+0000"],
[ new Date(1500,0,1).toString(), "Mon Jan 1 1500 00:00:00 GMT+0000"],
[ new Date(1500,0,1).getTime(), -14831769600000]
];

gmt.forEach(function(n) { if (n[0]==n[1]) pass++; });

E.setTimeZone(2);
var cest = [
[ Date.parse("2011-10-20") , 1319061600000.0 ],
[ Date.parse("2011-10-20T14:48:12.345") , 1319114892345.0 ],
[ Date.parse("Aug 9, 1995") , 807919200000.0 ],
[ new Date("Wed, 09 Aug 1995 00:00:00").getTime() , 807919200000.0 ],
[ Date.parse("Thu, 01 Jan 1970 00:00:00 GMT") , 0.0 ],
[ Date.parse("Thu, 01 Jan 1970 00:00:00 GMT-0100") , 3600000.0 ],
[ Date.parse("Mon, 25 Dec 1995 13:30:00 +0430"), 819882000000.0 ],
[ new Date(807926400000.0).toString() , "Wed Aug 9 1995 02:00:00 GMT+0200" ],
[ new Date("Fri, 20 Jun 2014 15:27:22 GMT").toString(), "Fri Jun 20 2014 17:27:22 GMT+0200"],
[ new Date("Fri, 20 Jun 2014 15:27:22 GMT").toISOString(), "2014-06-20T15:27:22.000Z"],
[ new Date("Fri, 20 Jun 2014 17:27:22 GMT+0200").toISOString(), "2014-06-20T15:27:22.000Z"]
];

cest.forEach(function(n) { if (n[0]==n[1]) pass++; });

// Northern hemisphere, +2h winter and +3h summer. Change last Sun Mar @ 3am and last Sun Oct @ 4am.
E.setDST(60,120,4,0,2,0,180,4,0,9,0,240);
var dst = [
[ new Date("2011-02-10T14:12:00").toLocalISOString() , "2011-02-10T14:12:00.000+0200" ],
[ new Date("2011-06-11T11:12:00").toLocalISOString() , "2011-06-11T11:12:00.000+0300" ],
[ new Date("2011-11-04T09:25:00").toLocalISOString() , "2011-11-04T09:25:00.000+0200" ],
[ new Date("2011-03-27T00:59:59.9Z").toLocalISOString() , "2011-03-27T02:59:59.900+0200" ],
[ new Date("2011-03-27T01:00:00.0Z").toLocalISOString() , "2011-03-27T04:00:00.000+0300" ],
[ new Date("2011-10-30T00:59:59.9Z").toLocalISOString() , "2011-10-30T03:59:59.900+0300" ],
[ new Date("2011-10-30T01:00:00.0Z").toLocalISOString() , "2011-10-30T03:00:00.000+0200" ]
];

dst.forEach(function(n) { if (n[0]==n[1]) pass++; });

// Southern hemisphere. -3h winter and -2h summer. Change 2nd Sun Mar @2am and 2nd Sun Oct @ 2am.
E.setDST(60,-180,1,0,9,0,120,1,0,2,0,120);
var dstSouth = [
[ new Date("2011-02-10T14:12:00").toLocalISOString() , "2011-02-10T14:12:00.000-0200" ],
[ new Date("2011-06-11T11:12:00").toLocalISOString() , "2011-06-11T11:12:00.000-0300" ],
[ new Date("2011-11-04T09:25:00").toLocalISOString() , "2011-11-04T09:25:00.000-0200" ],
[ new Date("2011-03-13T03:59:59.9Z").toLocalISOString() , "2011-03-13T01:59:59.900-0200" ],
[ new Date("2011-03-13T04:00:00.0Z").toLocalISOString() , "2011-03-13T01:00:00.000-0300" ],
[ new Date("2011-10-09T04:59:59.9Z").toLocalISOString() , "2011-10-09T01:59:59.900-0300" ],
[ new Date("2011-10-09T05:00:00.0Z").toLocalISOString() , "2011-10-09T03:00:00.000-0200" ]
];

dstSouth.forEach(function(n) { if (n[0]==n[1]) pass++; });

result = pass == gmt.length + cest.length + dst.length + dstSouth.length;
