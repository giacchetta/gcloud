## Variables
export ENVIROMENTS="services dev pro"

## Create Buckets for Services

for i in services dev pro
  do
    export GKE_ENV=gke-$i-1
    gsutil mb gs://$GKE_ENV
    echo "$GKE_ENV" > index.html
    gsutil cp index.html gs://$GKE_ENV
    gsutil iam ch allUsers:objectViewer gs://$GKE_ENV
    gsutil web set -m index.html gs://$GKE_ENV
    rm -f index.html
  done

## Create Backend Services
for i in $ENVIROMENTS
  do
    gcloud compute backend-buckets create backend-bucket-$i \
        --gcs-bucket-name=gke-$i-1
  done

# Import URL Maps
gcloud compute url-maps import gke-maps \
    --source=gke-maps-1.json

# Create Target Proxy
gcloud compute target-http-proxies create http-proxy-1 \
    --url-map=gke-maps

# Create Target Proxy
gcloud compute forwarding-rules create lb-1 \
    --load-balancing-scheme=EXTERNAL_MANAGED \
    --network-tier=PREMIUM \
    --global \
    --target-http-proxy=http-proxy-1 \
    --ports=80
    