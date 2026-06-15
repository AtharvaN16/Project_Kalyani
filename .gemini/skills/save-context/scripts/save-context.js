const fs = require('fs');
const path = require('path');

const filePath = process.argv[2];
const content = process.argv[3];

if (!filePath || !content) {
  console.error('Usage: node save-context.js <filePath> "<content>"');
  process.exit(1);
}

const dir = path.dirname(filePath);

fs.mkdir(dir, { recursive: true }, (err) => {
  if (err) {
    console.error(`Error creating directory: ${err.message}`);
    process.exit(1);
  }

  const contentToAppend = `

---

${content}`;

  fs.appendFile(filePath, contentToAppend, { encoding: 'utf8' }, (err) => {
    if (err) {
      console.error(`Error writing to file: ${err.message}`);
      process.exit(1);
    }

    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error(`Error reading file: ${err.message}`);
            process.exit(1);
        }

        const lines = data.split('\n').length;
        console.log(`✅ Successfully saved context to ${filePath}.`);

        if (lines > 200) {
            console.warn(`⚠️ Warning: ${filePath} now has ${lines} lines, which is over the 200-line limit.`);
        }
    });
  });
});
