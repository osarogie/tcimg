import { VercelApiHandler } from '@vercel/node'
import { downloadAndSend } from '../../[name]'

const S3_BUCKET = process.env.S3_BUCKET

const handler: VercelApiHandler = async function Image(req, res) {
  const name = req.query.name as string
  const dimensions = req.query.dimensions as string

  const awsFolder = `http://${S3_BUCKET}.s3.amazonaws.com/uploads`
  const downloadLink = `http://ahuswgemen.cloudimg.io/crop/${dimensions}/x/${awsFolder}/${name}`

  try {
    await downloadAndSend(`${name}-${dimensions}`, downloadLink, res)
  } catch (error) {
    console.log(error)

    res.status(500).json({ errors: [{ message: error.message }] })
    return
  }
}

export default handler
