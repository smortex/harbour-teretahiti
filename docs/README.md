After [downloading the .apk
file](https://apkpure.com/region-free-apk-download?p=com.spec.mobiv.teretahiti),
it can be extracted (it's a .zip file) and interesting data can be found in the
`assets/app.bundle` file:

```
siteBase:'http://locbusrtct.dataccessor.com:20082'

get(siteBase+'/api/bus/logs-course/'+t.id)
get(siteBase+'/api/disruption/active')
get(siteBase+'/api/places/all')
get(siteBase+'/api/routes/0')

post(siteBase+'/api/gtfs/trip',{date:t,time:this.state.timeTrip,from:this.state.fromLieuId,to:this.state.toLieuId})
post(siteBase+'/api/itinerary/running',{routeId:this.state.route.id,direction:this.state.direction})
post(siteBase+'/api/shape/get',{itineraryIds:[t],fullName:!0})
post(siteBase+'/api/shape/get',{itineraryIds:[this.state.itineraryId],fullName:!0})
post(siteBase+'/api/stop-time/next-line-live',{routeId:this.props.route.id,routeDirection:this.props.selectedRoute.direction})
post(siteBase+'/api/stop-time/next-line-live',{routeId:this.state.route.id,routeDirection:this.state.direction}
post(siteBase+'/api/stop-time/next-stop-live',{lieuId:t.id})
post(siteBase+'/api/stop-time/next-stop-live',{lieuId:t})
```

We can then use `curl(1)` to get data from these API endpoints, .e.g:

```
curl -d '{"routeId":"1034","routeDirection":0}' http://locbusrtct.dataccessor.com:20082/api/stop-time/next-line-live
```

The `scan/scan.sh` script automates fetching some URL's result for reverse engeenering the data provided by this API.

The `teretahiti.pcap` file contains a dump of all traffic on port 20082 when
running the application in an [android
emulator](https://developer.android.com/studio/run/emulator).  The application
was started at 15:15 GMT-10, I browsed into _lines_, _11 PPT > PAMATAI_,
clicked on _Fare tony_.  Then at 15:17 _stops_, _Faa'a école Pamatai_.
