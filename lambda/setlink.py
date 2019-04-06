import boto3
import os
import hashlib
import base64

def lambda_handler(event, context):

	# URL
	#url = "https://www.startpage.com"
	url = event['createlink']
	
	if not (url.lower().startswith('http://') or url.lower().startswith('https://')):
		url = "http://" + url

	# Generate random linkname
	linkname = hash(url)

	# Use Amazon S3: http://boto3.readthedocs.io/en/latest/reference/services/s3.html#id185
	s3 = boto3.client('s3')

	# Upload a new file into an S3 bucket
	bucket = os.environ['BUCKET_NAME']
	key = os.environ['DIRECTORY'] + linkname
	data = url.encode()
	s3.put_object(Bucket=bucket, Key=key, Body=data)
	
	resp = {
		"link": "dyn.link/" + linkname,
		#"destination": url
		"status": "OK"
	}
	return resp

# Get bytes of the MD5 hash of the URL, encode those into modified Base64 for URLs and trim the resulting string to 6 characters
def hash(input):
    hash = hashlib.md5(input.encode('utf-8'))
    return base64.urlsafe_b64encode(hash.digest())[:6].decode("utf-8")
