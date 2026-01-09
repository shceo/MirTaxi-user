const fs = require('fs');
const path = require('path');
let text = fs.readFileSync('lib/src/presentation/translations/translation.dart','utf8');
text = text.replace(/^Map<String, dynamic>\s+languages\s*=\s*/,'');
text = text.trim();
if (text.endsWith(';')) text = text.slice(0, -1);
const languages = eval('(' + text + ')');
const outDir = path.join('lib','l10n');
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, {recursive:true});
for (const [code, entries] of Object.entries(languages)) {
  fs.writeFileSync(path.join(outDir, `app_${code}.arb`), JSON.stringify(entries, null, 2));
}
console.log('Written', Object.keys(languages));
