# helm_container
Docker container for serving Helm Charts

## Notes

* SSL is not currently supported.
* Map volume to `/web/html`
* nginx runs on port 80
* helm is installed in /usr/local/bin

## TODO

* Add script to accept upload of helm chart 
  * Store file to html root
  * Run helm repo index `DIR`

