const fs = require('fs');
const path = require('path');
const dir = path.join('lib','l10n');
const renameMap = {
  'text testing': 'text_testing',
  'Money Deposited': 'money_deposited',
  'Admin Commission For Trip': 'admin_commission_for_trip',
  'Trip Commission': 'trip_commission',
  'Cancellation Fee': 'cancellation_fee_title',
  'Money Deposited By Admin': 'money_deposited_by_admin',
  'Referral Commission': 'referral_commission',
  'Spent For Trip Request': 'spent_for_trip_request',
  'Withdrawn From Wallet': 'withdrawn_from_wallet',
};
for (const file of fs.readdirSync(dir).filter(f => f.endsWith('.arb'))) {
  const full = path.join(dir, file);
  const data = JSON.parse(fs.readFileSync(full, 'utf8'));
  for (const [oldKey, newKey] of Object.entries(renameMap)) {
    if (oldKey in data) {
      const value = data[oldKey];
      delete data[oldKey];
      if (!(newKey in data)) data[newKey] = value;
    }
  }
  if ('text_approval_wayting' in data) {
    const value = data['text_approval_wayting'];
    delete data['text_approval_wayting'];
    if (!('text_approval_waiting' in data)) {
      data['text_approval_waiting'] = value;
    }
  }
  fs.writeFileSync(full, JSON.stringify(data, null, 2));
  console.log('fixed', file);
}
