import boto3
import json
import logging

s3_client = boto3.client('s3')

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Assuming the JSON file is passed as the 'file_content' key in the event
    file_content = event.get('file_content')
    
    if file_content:
        try:
            # Load the JSON content
            data = json.loads(file_content)
            
            # Example: Bucket name and file name where you want to upload the JSON
            bucket_name = 'c9-wv-poc'
            file_name = 'uploaded_file.json'
            
            # Upload JSON file to S3
            s3_client.put_object(Body=json.dumps(data), Bucket=bucket_name, Key=file_name)
            
            # Log success
            logger.info({
                'statusCode': 200,
                'message': 'File uploaded successfully to S3',
                'bucket_name': bucket_name,
                'file_name': file_name
            })
            
            return {
                'statusCode': 200,
                'body': json.dumps('File uploaded successfully to S3')
            }
        except Exception as e:
            # Log error
            logger.error({
                'statusCode': 500,
                'error_message': str(e)
            })
            
            return {
                'statusCode': 500,
                'body': json.dumps(f'Error: {str(e)}')
            }
    else:
        # Log missing file content
        logger.warning({
            'statusCode': 400,
            'message': 'No file content provided'
        })
        
        return {
            'statusCode': 400,
            'body': json.dumps('No file content provided')
        }
