# Donation to Inventory Flow - Implementation Guide

## Overview
When an admin approves a donation, it automatically gets added to the inventory system and becomes available for rental/reservation.

## How It Works

### 1. **User Submits Donation**
   - User fills out the donation form (`donation_form.dart`)
   - Data is saved to Firestore `donations` collection with status: `pending`
   - User can track their donations in the Tracking tab

### 2. **Admin Reviews Donation**
   - Admin navigates to Donations section
   - Views pending donations in the Tracking tab
   - Clicks on a donation to see full details (`details.dart`)

### 3. **Admin Approves Donation** ✨
   - Admin sees "Approve" and "Reject" buttons (only for pending donations)
   - When clicking "Approve":
     - ✅ Creates new document in `inventory` collection with:
       - name, category, status: 'available', quantity, condition
       - source: 'donation' (tracks that it came from a donation)
       - donationId (link back to original donation)
     - ✅ Updates donation status to 'approved'
     - ✅ Shows success message
     - ✅ Returns to previous screen

### 4. **Inventory Updated**
   - `inventory_admin.dart` now uses **StreamBuilder** with Firestore
   - Automatically displays newly approved donations
   - Real-time updates - no refresh needed
   - Shows: name, category, status, quantity, condition, source

### 5. **Available for Rental**
   - Approved donations now appear in inventory list
   - Users can browse and reserve these items
   - Status can be updated (Available → Rented → Maintenance)

## Files Modified

### 1. `lib/Donation/details.dart`
**Added:**
- `_approveDonation()` - Moves donation to inventory
- `_rejectDonation()` - Updates status to rejected
- `_getUserRole()` - Checks if user is admin
- `_getCategoryFromIcon()` - Maps icon keys to categories
- Admin action buttons UI (Approve/Reject)

### 2. `lib/inventory/inventory_admin.dart`
**Changed:**
- Removed hardcoded inventory items
- Added **StreamBuilder** to fetch from Firestore
- Real-time inventory updates
- Filter by search query and status
- Display source (donation vs manual entry)

## Firestore Collections

### `donations` Collection
```json
{
  "itemName": "Wheelchair",
  "condition": "Good",
  "description": "Manual wheelchair, lightly used",
  "quantity": 1,
  "status": "pending", // or "approved", "rejected"
  "donorId": "user123",
  "iconKey": "wheelchair",
  "createdAt": Timestamp
}
```

### `inventory` Collection
```json
{
  "name": "Wheelchair",
  "category": "Mobility Aid",
  "status": "available", // or "rented", "maintenance"
  "quantity": 1,
  "condition": "Good",
  "description": "Manual wheelchair, lightly used",
  "source": "donation", // or "manual"
  "donationId": "donation123", // reference to original donation
  "iconKey": "wheelchair",
  "addedAt": Timestamp
}
```

## Firestore Index Needed

Run this command or add through Firebase Console:

```bash
# Index for inventory collection
Collection ID: inventory
Fields: addedAt (Descending)
```

Or add to `firestore.indexes.json`:
```json
{
  "indexes": [
    {
      "collectionGroup": "inventory",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "addedAt",
          "order": "DESCENDING"
        }
      ]
    }
  ]
}
```

## Admin Workflow

1. **View Pending Donations:**
   - Go to Donations tab
   - Click "Tracking" tab
   - See list of all pending donations

2. **Review Donation Details:**
   - Click on any donation card
   - See full details: item name, condition, quantity, description, images

3. **Approve or Reject:**
   - If good quality → Click "Approve" → Added to inventory
   - If not suitable → Click "Reject" → Status updated, NOT added to inventory

4. **Check Inventory:**
   - Go to Inventory Management
   - See newly approved donation in the list
   - Can view/edit/delete as normal inventory item

## User Benefits

✅ **For Donors:**
- Easy donation submission
- Track donation status in real-time
- See when donation is approved and added to inventory

✅ **For Admins:**
- Review donations before adding to inventory
- Maintain quality control
- Track donation sources
- Simple approve/reject workflow

✅ **For Renters:**
- Access to more equipment
- Know which items came from donations
- Same rental process for all items

## Next Steps (Optional Enhancements)

1. **Notifications:**
   - Send email/push notification to donor when approved
   - Notify admins of new pending donations

2. **Image Upload:**
   - Add photo upload to donation form
   - Display images in details page

3. **Location Tracking:**
   - Add location field to donations
   - Auto-populate inventory location

4. **Statistics:**
   - Track total donations approved
   - Show donation impact dashboard
   - Monthly donation reports

## Testing

1. **Submit a donation** as a regular user
2. **Login as admin** (role: 'admin' in users collection)
3. **Navigate to Donations → Tracking**
4. **Click on the pending donation**
5. **Click "Approve"**
6. **Go to Inventory Management**
7. **Verify the item appears** in the inventory list

Done! 🎉
