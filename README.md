# cointrail

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# CoinTrail

## Auto Transaction Processing

### Enhanced Duplicate Prevention System

The app now implements a **4-layer duplicate prevention system**:

#### 1. **SMS-Level Deduplication**
- Android `PendingSmsStore` checks for duplicate SMS text
- Prevents same SMS from being stored multiple times

#### 2. **Content-Based Unique IDs**
- Transactions get IDs based on: `amount_title_hour_smsHash`
- Same transaction content = Same ID = Automatic deduplication
- Example: `150.0_Swiggy_123456_789012`

#### 3. **Similarity Detection**
- Checks for similar transactions within 2-hour window
- 70% title similarity threshold using Jaccard algorithm
- Compares against both pending and confirmed transactions

#### 4. **Real-time Processing**
- Periodic SMS polling (every 10 seconds when app active)
- Immediate processing when app resumes from background
- No more hot reloads needed!

### Flow Diagram

```
📩 SMS Arrives
   ↓
🔄 SmsReceiver saves to SharedPreferences (with duplicate check)
   ↓
🔔 Notification shown (if app killed/background)
   ↓
⏰ App polls every 10s OR user opens app
   ↓
🔍 Multiple duplicate checks performed:
   • Raw SMS comparison
   • Content-based unique ID
   • Transaction similarity analysis
   • Time-window validation
   ↓
✅ SMS processed → PendingTransaction created (if unique)
   ↓
📱 User sees in Inbox immediately
   ↓
✏️ User edits → Transaction saved with same unique ID
   ↓
🗑️ PendingTransaction removed automatically
```

### Duplicate Scenarios Handled

1. **Same SMS received multiple times** → Blocked at SMS level
2. **Network retries causing re-processing** → Blocked by unique ID  
3. **User manually adding detected transaction** → Blocked by similarity check
4. **App crash during processing** → Consistent IDs prevent duplicates on restart
5. **Multiple similar transactions** → Time-window validation allows legitimate duplicates

### Smart Duplicate Detection Features

#### **Frequent Merchant Logic**
- Allows multiple transactions from coffee shops, transport, etc.
- Minimum 15-minute gap required for same merchant/amount
- Examples: Multiple Uber rides, coffee purchases, parking fees

#### **Content-Based Unique IDs**
```dart
// Example ID generation
SmsTransactionParser.generateTransactionId(
  amount: 150.0,
  title: "Swiggy", 
  date: DateTime.now(),
  rawSms: "Debited Rs.150 to Swiggy..."
);
// Result: "150.0_Swiggy_1642781234_987654321"
```

#### **Automatic Cleanup**
- Removes pending transactions older than 7 days
- Prevents storage bloat from unprocessed SMS
- Runs on app startup

### Configuration

**Polling Interval:** 10 seconds (when app active)  
**Similarity Threshold:** 70% title match  
**Time Window:** 2 hours for duplicates, 15 minutes for frequent merchants  
**Auto-cleanup:** 7 days for pending transactions

## Architecture Overview




Settings page
↓
UserRepository.updateUserName()
↓
UserHiveSource.saveUser()
↓
userBox emits change event
↓
HomeController listener fires
↓
_loadUser()
↓
notifyListeners()
↓
HomeHeader rebuilds



TODO: Add Month Filter in All Transaction
TODO: Analysis Page 
TODO: Add Scan Receipt
TODO: Push Notification




CategoryHiveSource
   ↓
SettingsController (owner)
   ↓
CategoryModel (Hive)
   ↓
Transactions store categoryId
   ↓
Analysis / Charts JOIN by categoryId
'




Native SMS → PendingTransaction created
           → PendingTransactionService.notifyPendingCreated()

User opens Inbox
→ Tap Pending
→ Edit
→ Save
→ PendingTransactionService.removePending()
→ Activity logged
→ Notification cleared







SMS Arrives
   ↓
🔄 SmsReceiver saves to SharedPreferences  
   ↓
🔔 Notification shown (if app killed/background)
   ↓
⏰ App polls every 10s OR user opens app
   ↓
✅ SMS processed → PendingTransaction created
   ↓
📱 User sees in Inbox immediately
   ↓
✏️ User edits → Transaction saved
   ↓
🗑️ PendingTransaction removed automatically