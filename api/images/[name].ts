import { VercelApiHandler, VercelResponse } from '@vercel/node'
import fs from 'fs'
import http from 'http'

const S3_BUCKET = process.env.S3_BUCKET

const handler: VercelApiHandler = async function Image(req, res) {
  const name = req.query.name as string

  const awsFolder = `http://${S3_BUCKET}.s3.amazonaws.com/uploads`
  const downloadLink = `${awsFolder}/${name}`

  try {
    await downloadAndSend(name, downloadLink, res)
  } catch (error) {
    res.status(500).json({ errors: [{ message: error.message }] })
    return
  }
}

export default handler

export async function downloadAndSend(fileName: string, downloadLink: string, res: VercelResponse) {
  const folder = '/tmp/images'
  fs.mkdirSync(folder, { recursive: true })
  const fileLocation = `${folder}/${fileName}`

  if (!fs.existsSync(fileLocation)) {
    await downloadImage(downloadLink, fileLocation)
  }

  const imageBuffer = fs.readFileSync(fileLocation)

  res.setHeader('Expires', new Date(Date.now() + 31536000000).toUTCString())
  res.setHeader('Content-Type', 'image/jpeg')
  res.send(imageBuffer)
}

export async function downloadImage(url: string, filePath: string) {
  return new Promise((resolve, reject) => {
    http.get(url, (res) => {
      if (res.statusCode === 200) {
        res
          .pipe(fs.createWriteStream(filePath))
          .on('error', reject)
          .once('close', () => resolve(filePath))
      } else {
        // Consume response data to free up memory
        res.resume()
        reject(new Error(`Request Failed With a Status Code: ${res.statusCode}`))
      }
    })
  })
}
