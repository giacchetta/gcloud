## Variables
export ENVIROMENTS="services dev pro"

# Delete Forwarding Rules
gcloud compute forwarding-rules delete lb-1

# Delete Target Proxy
gcloud compute target-http-proxies delete http-proxy-1

# Delete URL Maps
gcloud compute url-maps delete gke-maps

## Create Backend Services
for i in $ENVIROMENTS
  do
    gcloud compute backend-buckets delete backend-bucket-$i
  done

## Create Buckets for Services

for i in services dev pro
  do
    export GKE_ENV=gke-$i-1
    gsutil rm -r gs://$GKE_ENV
  done
