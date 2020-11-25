const express = require('express');

const app = express();
const PORT = 8000;

app.get('/', (req, res) => {
  res.send({ home: 'Home' })
});

app.listen(PORT, () => {
  console.log(`Application running on http://localhost:${PORT}/`)
});
