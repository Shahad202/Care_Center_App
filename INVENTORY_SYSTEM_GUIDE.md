# Inventory System - Admin & User Views

## Overview
Separate, optimized inventory views for admins and regular users with enhanced UI and full CRUD operations.

## New Files Created

### 1. `lib/inventory/inventory_admin_new.dart` - Admin View
**Features:**
- ✅ **Add Equipment**: Full form with all fields
  - ID (auto-generated)
  - Name, Type/Category
  - Description
  - Condition
  - Quantity
  - Location
  - Tags (comma-separated)
  - Availability Status (Available/Rented/Maintenance)
  - Rental Price Per Day (optional)

- ✅ **Edit Equipment**: Update any field
- ✅ **Delete Equipment**: With confirmation dialog
- ✅ **View Modes**: Toggle between Grid and List view
- ✅ **Search**: Real-time search by name
- ✅ **Filter**: By status (All/Available/Rented/Maintenance)
- ✅ **Detailed View**: Bottom sheet with all information

**UI Features:**
- Modern card-based design
- Status color coding (Green/Orange/Red)
- Responsive grid/list layouts
- Material 3 design
- Icon-based category representation

### 2. `lib/inventory/inventory_user.dart` - User View
**Features:**
- ✅ **Browse Equipment**: Only shows available items
- ✅ **View Modes**: Toggle between Grid and List view
- ✅ **Search**: By equipment name
- ✅ **Filter by Category**: All/Mobility Aid/Medical Device/Furniture/Other
- ✅ **Item Details**: Tap to see full information
- ✅ **Reserve**: Direct link to reservation page

**UI Features:**
- Clean, user-friendly interface
- Category-based filtering
- Large, easy-to-tap cards
- Price display (when available)
- Availability badges
- Draggable detail sheets

## Routes Updated in `main.dart`

```dart
'/inventory' → InventoryUserWidget() // For regular users
'/inventory_admin' → InventoryAdminWidget() // For admins
```

## Database Structure

### Firestore `inventory` Collection
```json
{
  "id": "auto-generated",
  "name": "Wheelchair",
  "category": "Mobility Aid",
  "description": "Electric wheelchair with joystick control",
  "condition": "Good",
  "quantity": 3,
  "location": "Main Storage",
  "tags": ["electric", "outdoor", "portable"],
  "status": "available", // available | rented | maintenance
  "rentalPricePerDay": 50.0, // optional
  "source": "manual", // manual | donation
  "addedAt": Timestamp,
  "donationId": "optional-if-from-donation"
}
```

## Key Differences: Admin vs User View

| Feature | Admin View | User View |
|---------|-----------|-----------|
| **Access** | `/inventory_admin` | `/inventory` |
| **Items Shown** | All (all statuses) | Only available |
| **Actions** | Add/Edit/Delete | View/Reserve |
| **Filters** | Status-based | Category-based |
| **Details** | Full CRUD access | Read-only |
| **Price** | Can edit | Display only |
| **Design** | Management-focused | Shopping-focused |

## Usage Instructions

### For Admin Users:
1. Navigate to `/inventory_admin`
2. **Add Item**: Click floating "Add Item" button
3. **Edit**: Click any item → Click "Edit" button
4. **Delete**: Click item → Click "Delete" button (with confirmation)
5. **Switch Views**: Use top-right icon to toggle grid/list
6. **Filter**: Use status chips (All/Available/Rented/Maintenance)

### For Regular Users:
1. Navigate to `/inventory` (default from home page)
2. **Browse**: Scroll through available equipment
3. **Filter**: Select category chip
4. **Search**: Type equipment name
5. **View Details**: Tap any card
6. **Reserve**: Click "Reserve Now" in detail sheet

## Navigation Updates Needed

### Update Drawer/Menu Links:
```dart
// For regular users
ListTile(
  title: Text('Browse Equipment'),
  onTap: () => Navigator.pushNamed(context, '/inventory'),
)

// For admin users
ListTile(
  title: Text('Manage Inventory'),
  onTap: () => Navigator.pushNamed(context, '/inventory_admin'),
)
```

### Role-Based Routing Example:
```dart
void _navigateToInventory(BuildContext context, String role) {
  if (role == 'admin') {
    Navigator.pushNamed(context, '/inventory_admin');
  } else {
    Navigator.pushNamed(context, '/inventory');
  }
}
```

## UI Color Scheme

**Status Colors:**
- Available: Green (`#10B981`)
- Rented: Orange (`#F59E0B`)
- Maintenance: Red (`#EF4444`)

**Brand Colors:**
- Primary: Navy Blue (`#003465`)
- Secondary: Light Blue (`#1874CF`)
- Background: Light Gray (`#F9FAFB`)

## Next Steps

1. **Update Navigation**: Change existing inventory links to use `/inventory` for users
2. **Admin Dashboard**: Add link to `/inventory_admin`
3. **Permissions**: Add role checking before accessing admin view
4. **Images**: Add image upload functionality (optional)
5. **Analytics**: Track inventory usage and popular items

## Testing Checklist

### Admin View:
- [ ] Add new item with all fields
- [ ] Edit existing item
- [ ] Delete item
- [ ] Toggle between grid/list views
- [ ] Search functionality
- [ ] Filter by status
- [ ] View detailed information

### User View:
- [ ] Browse available items
- [ ] Filter by category
- [ ] Search equipment
- [ ] Toggle views
- [ ] View item details
- [ ] Reserve button navigation

## Benefits

✅ **Separation of Concerns**: Clear distinction between admin and user interfaces
✅ **Better UX**: Tailored experience for each user type
✅ **Full CRUD**: Complete inventory management for admins
✅ **Modern UI**: Material 3 design with smooth animations
✅ **Responsive**: Works on all screen sizes
✅ **Flexible Views**: Grid and list options
✅ **Rich Data**: Support for tags, pricing, conditions, etc.

Done! 🎉
