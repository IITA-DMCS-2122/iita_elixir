const http = require("https");

const options = {
  "method": "POST",
  "hostname": "api.pagerduty.com",
  "port": null,
  "path": "/incidents",
  "headers": {
    "Content-Type": "application/json",
    "Accept": "application/vnd.pagerduty+json;version=2",
    "From": "iitaelixir@gmail.com",
    "Authorization": "Token token=e+U8z5izJ58vXdzTR-gw"
  }
};

const req = http.request(options, function (res) {
  const chunks = [];

  res.on("data", function (chunk) {
    chunks.push(chunk);
  });

  res.on("end", function () {
    const body = Buffer.concat(chunks);
    console.log(body.toString());
  });
});

var uniqid = Date.now();

req.write(JSON.stringify({
  incident: {
    type: 'incident',
    title: 'The server is on fire.',
    service: {id: 'PVBX9SL', type: 'service_reference'},
    priority: {id: 'P53ZZH5', type: 'priority_reference'},
    urgency: 'high',
    incident_key: uniqid.toString(),
    body: {
      type: 'incident_body',
      details: 'A disk is getting full on this machine. You should investigate what is causing the disk to fill, and ensure that there is an automated process in place for ensuring data is rotated (eg. logs should have logrotate around them). If data is expected to stay on this disk forever, you should start planning to scale up to a larger disk.'
    }
  }
}));
req.end();
