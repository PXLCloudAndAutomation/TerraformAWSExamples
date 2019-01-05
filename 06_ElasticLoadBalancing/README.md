Outputs:

address = WEB-ELB-13407086.us-east-1.elb.amazonaws.com
test_command = wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
web_private_ips = [
    10.0.0.98,
    10.0.0.251
]
web_public_ips = [
    54.166.170.52,
    3.80.150.74
]

wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.98</h1>
wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.98</h1>
wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.251</h1>
wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.98</h1>
wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.251</h1>
wget WEB-ELB-13407086.us-east-1.elb.amazonaws.com 2>/dev/null ; cat index.html | grep served ; rm index.html
        <h1>This page was served from 10.0.0.98</h1>
