import { app } from "./index";
import { config } from 'dotenv';
config()
const PORT = process.env.PORT

app.listen(PORT, () => console.log('App started on port', PORT))