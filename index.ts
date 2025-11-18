import express, {Express, Request, Response} from 'express';
import { pool } from './db';

import { config } from 'dotenv';
import { createServer } from 'https';
import fs from 'fs';
config()
const PORT = Number(process.env.PORT )|| 3000

export const app:Express = express()

app.use(express.json())

// const server = createServer({
//   cert: fs.readFileSync("./cert/keme.local.pem"),
//   key: fs.readFileSync("./cert/keme.local-key.pem")
// }, app)

app.get('/', (req: Request, res: Response) => {
    res.json({status: "all good 👍"})
})

app.post('/users', async (req: Request, res: Response) => {
  const { name, email, password } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO users (name, email, password)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [name, email, password]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to insert user' });
  }
})

app.get('/users', async (req: Request, res: Response) => {

    try {
        const results = await pool.query(`
            SELECT * FROM users
        `)
        res.json(results.rows)
    }
    catch(error) {
        console.log(error)
    }

})

// server.listen(PORT, "0.0.0.0", () => console.log('App started on port', PORT))
app.listen(PORT, "0.0.0.0", () => console.log('App started on port', PORT))