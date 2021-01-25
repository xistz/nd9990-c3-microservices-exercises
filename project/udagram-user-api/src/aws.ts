import AWS = require('aws-sdk');
import { config } from './config/config';

// Configure AWS
const credentials = new AWS.Credentials(
  config.awsAccessKeyId,
  config.awsSecretAccessKey
);
AWS.config.credentials = credentials;

export const s3 = new AWS.S3({
  signatureVersion: 'v4',
  region: config.awsRegion,
  params: { Bucket: config.awsMediaBucket },
});

// Generates an AWS signed URL for retrieving objects
export function getGetSignedUrl(key: string): string {
  const signedUrlExpireSeconds = 60 * 5;

  return s3.getSignedUrl('getObject', {
    Bucket: config.awsMediaBucket,
    Key: key,
    Expires: signedUrlExpireSeconds,
  });
}

// Generates an AWS signed URL for uploading objects
export function getPutSignedUrl(key: string): string {
  const signedUrlExpireSeconds = 60 * 5;

  return s3.getSignedUrl('putObject', {
    Bucket: config.awsMediaBucket,
    Key: key,
    Expires: signedUrlExpireSeconds,
  });
}
