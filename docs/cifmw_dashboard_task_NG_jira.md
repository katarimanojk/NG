mount_cert passed to ceph_cli.yaml will bind mount /etc/pki/tls, so you .crt and .key should be here








Testing:



[cloud-admin@edpm-compute-0 ~]$ curl -k http://172.18.0.102:8444                                                                                                                      [2/1890]
<!DOCTYPE html><html lang="en-US" dir="ltr"><head>
  <meta charset="utf-8">
  <title>Ceph</title>

  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="icon" type="image/x-icon" id="cdFavicon" href="favicon.ico">
<style>@charset "UTF-8";:root{--white:#fff;--gray-100:#f8f9fa;--gray-200:#e9ecef;--gray-300:#dee2e6;--gray-400:#ced4da;--gray-500:#adb5bd;--gray-600:#6c757d;--gray-700:#495057;--gray-800:#34
3a40;--gray-900:#212529;--black:#000;--blue:#007bff;--indigo:#6610f2;--purple:#6f42c1;--pink:#a94442;--red:#dc3545;--orange:#fd7e14;--yellow:#d48200;--green:#008a00;--teal:#20c997;--cyan:#17
a2b8;--barley-white:#fcecba;--primary:#25828e;--primary-500:#2b99a8;--secondary:#374249;--success:#008a00;--info:#25828e;--warning:#d48200;--danger:#dc3545;--light:#f8f9fa;--dark:#343a40;--g
reen-300:#6ec664;--cyan-300:#009596;--purple-300:#a18fff;--light-blue-300:#35caed;--gold-300:#f4c145;--light-green-300:#ace12e;--accent:#25828e;--warning-dark:#fd7e14;--fg-color-over-dark-bg
:#fff;--fg-hover-color-over-dark-bg:#adb5bd;--body-color-bright:#f8f9fa;--body-bg:#fff;--body-color:#212529;--body-bg-alt:#e9ecef;--health-color-error:#dc3545;--health-color-healthy:#008a00;
--health-color-warning:#d48200;--health-color-warning-800:#9d6d10;--chart-color-red:#dc3545;--chart-color-blue:#06c;--chart-color-orange:#ef9234;--chart-color-yellow:#f6d173;--chart-color-gr
een:#008a00;--chart-color-gray:#ededed;--chart-color-cyan:#2b99a8;--chart-color-light-gray:#f0f0f0;--chart-color-slight-dark-gray:#d7d7d7;--chart-color-dark-gray:#afafaf;--chart-color-purple
:#3c3d99;--chart-color-white:#fff;--chart-color-center-text:#151515;--chart-color-center-text-description:#72767b;--chart-color-tooltip-background:#000;--chart-danger:#c9190b;--chart-color-s
trong-blue:#0078c8;--chart-color-translucent-blue:#0096dc80;--font-family-sans-serif:"Helvetica Neue", Helvetica, Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Sego
e UI Symbol", "Noto Color Emoji";--card-cap-bg:#f8f9fa;--grid-gutter-width:30px;--datatable-divider-color:rgba(0, 0, 0, .09);--nav-tabs-margin-bottom:1rem;--tooltip-color:#fff;--tooltip-bg:#
212529;--tooltip-opacity:1;--screen-sm-min:576px;--screen-md-min:768px;--screen-lg-min:992px;--screen-xl-min:1200px;--screen-xs-max:575px;--screen-sm-max:767px;--screen-md-max:991px;--screen
-lg-max:1199px;--navbar-height:43px}:root{--bs-blue:#007bff;--bs-indigo:#6610f2;--bs-purple:#6f42c1;--bs-pink:#a94442;--bs-red:#dc3545;--bs-orange:#fd7e14;--bs-yellow:#d48200;--bs-green:#008
a00;--bs-teal:#20c997;--bs-cyan:#17a2b8;--bs-white:#fff;--bs-gray:#6c757d;--bs-gray-dark:#343a40;--bs-accent:#25828e;--bs-warning-dark:#fd7e14;--bs-primary:#25828e;--bs-secondary:#374249;--b
s-success:#008a00;--bs-info:#25828e;--bs-warning:#d48200;--bs-danger:#dc3545;--bs-light:#f8f9fa;--bs-dark:#343a40;--bs-font-sans-serif:"Helvetica Neue", Helvetica, Arial, "Noto Sans", sans-s
erif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";--bs-font-monospace:SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;--
bs-gradient:linear-gradient(180deg, rgba(255, 255, 255, .15), rgba(255, 255, 255, 0))}*,*:before,*:after{box-sizing:border-box}@media (prefers-reduced-motion: no-preference){:root{scroll-beh
avior:smooth}}body{margin:0;font-family:var(--bs-font-sans-serif);font-size:1rem;font-weight:400;line-height:1.5;color:#212529;background-color:#fff;-webkit-text-size-adjust:100%;-webkit-tap
-highlight-color:rgba(0,0,0,0)}html{background-color:#fff}html,body{font-size:12px;height:100%;width:100%}</style><link rel="stylesheet" href="styles.84a45510313e718c.css" media="print" onlo
ad="this.media='all'"><noscript><link rel="stylesheet" href="styles.84a45510313e718c.css"></noscript></head>
<body>
  <noscript>
    <div class="noscript container"
         ng-if="false">
      <div class="jumbotron alert alert-danger">
        <h2 i18n>JavaScript required!</h2>
        <p i18n>A browser with JavaScript enabled is required in order to use this service.</p>
        <p i18n>When using Internet Explorer, please check your security settings and add this address to your trusted sites.</p>
      </div>
    </div>
  </noscript>

  <cd-root></cd-root>
<script src="runtime.4bd595c16d7c473d.js" type="module"></script><script src="polyfills.4b60b22744014b0b.js" type="module"></script><script src="scripts.cfd741a72b67f696.js" defer></script><
script src="main.8be028f171baab96.js" type="module"></script>

==========
with tls


##use the command below and generate the self-signed cet and key on edpm-0 node

cd /etc/pki/tls;
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -nodes -keyout example.com.key -out example.com.crt -subj "/CN=example.com" \
  -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"



#cifmw_cephadm_dashboard_crt: "/etc/pki/tls/example.com.crt"
#cifmw_cephadm_dashboard_key: "/etc/pki/tls/example.com.key"


cloud-admin@edpm-compute-0 tls]$ openssl s_client -connect 172.18.0.102:8444   
CONNECTED(00000003)                                                          
Can't use SSL_get_servername                                                                                                                                                                 
depth=0 CN = example.com                                                     
verify error:num=18:self-signed certificate 



[cloud-admin@edpm-compute-0 certs]$ curl -k https://172.18.0.102:8444/                                                                                                                        
<!DOCTYPE html><html lang="en-US" dir="ltr"><head>                                                                                                                                            
  <meta charset="utf-8">                                                                                                                                                                      
  <title>Ceph</title>                                                                                                                                                                         
                                                                                                            
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">




# improvements to validation


$ URL=https://example.com
$ curl http://172.18.0.102:8444 -s -o /dev/null -w "response_code: %{http_code} dns_time: %{time_namelookup} connect_time: %{time_connect} pretransfer_time: %{time_pretransfer} starttransfer_time: %{time_starttransfer} total_time: %{time_total}
response_code: 200

dns_time: 0.029
connect_time: 0.046
pretransfer_time: 0.203
starttransfer_time: 0.212
total_time: 0.212

