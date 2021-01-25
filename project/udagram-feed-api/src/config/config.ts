export const config = {
  username: process.env.POSTGRES_USERNAME,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  host: process.env.POSTGRES_HOST,
  dialect: 'postgres',
  awsRegion: process.env.AWS_REGION,
  awsAccessKeyId: process.env.AWS_BUCKET_ACCESS_KEY_ID,
  awsSecretAccessKey: process.env.AWS_BUCKET_SECRET_ACCESS_KEY,
  awsMediaBucket: process.env.AWS_BUCKET,
  url: process.env.URL,
  jwt: {
    secret: process.env.JWT_SECRET,
  },
};
