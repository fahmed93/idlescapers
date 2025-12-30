# Login System Visual Guide

## Screen Flow

This document describes the visual flow and appearance of the new login system.

## 1. Login Screen (scenes/login.tscn)

### Initial State - Login View
```
┌──────────────────────────────────────────────────┐
│                                                  │
│                SkillForge Idle                   │
│                                                  │
│                      Login                       │
│                                                  │
│  Username:                                       │
│  [Enter username...]                             │
│                                                  │
│  Password:                                       │
│  [Enter password...]                             │
│                                                  │
│  [Error message area - red text]                 │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │              LOGIN                         │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │         Create Account                     │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Features:**
- Large "SkillForge Idle" title at top (36pt font)
- "Login" subtitle (24pt font)
- Username input field (40px height)
- Password input field (40px height, secret mode)
- Error label for validation messages (red color)
- Large "LOGIN" button (50px height, 18pt font)
- "Create Account" button to switch views (40px height)
- Dark blue-gray background (#1F232E)
- All fields support keyboard entry
- Enter key submits the form

### Create Account View
```
┌──────────────────────────────────────────────────┐
│                                                  │
│                SkillForge Idle                   │
│                                                  │
│                 Create Account                   │
│                                                  │
│  Username (min 3 characters):                    │
│  [Enter username...]                             │
│                                                  │
│  Password (min 6 characters):                    │
│  [Enter password...]                             │
│                                                  │
│  Confirm Password:                               │
│  [Re-enter password...]                          │
│                                                  │
│  [Error message area - red text]                 │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │         CREATE ACCOUNT                     │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │          Back to Login                     │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
└──────────────────────────────────────────────────┘
```

**Features:**
- Same title and dark background as login view
- "Create Account" subtitle (24pt font)
- Three input fields with clear labels showing requirements
- All password fields in secret mode
- Error label for validation feedback
- "CREATE ACCOUNT" button (50px height, 18pt font)
- "Back to Login" button to return to login view
- Enter key on last field submits the form

**Validation:**
- Username: 3-20 characters, required
- Password: 6-50 characters, required
- Confirm Password: must match password
- Shows specific error messages for each validation failure

## 2. Character Selection Screen (scenes/startup.tscn)

### Updated with Account Info
```
┌──────────────────────────────────────────────────┐
│                                                  │
│                SkillForge Idle                   │
│              Logged in as: username              │
│  ┌────────────────────────────────────────────┐ │
│  │                 LOGOUT                     │ │
│  └────────────────────────────────────────────┘ │
│         Select or Create a Character             │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Slot 1 - Empty                 ┌────────┐ │ │
│  │                                 │ Create │ │ │
│  │                                 │Character│ │
│  │                                 └────────┘ │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Hero Name                      ┌────────┐ │ │
│  │  Total Level: 250 | XP: 123456  │  Play  │ │ │
│  │  Created: 2024-12-21 14:00      │────────│ │ │
│  │  Last Played: 2024-12-21 15:30  │ Delete │ │ │
│  │                                 └────────┘ │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  Slot 3 - Unavailable                      │ │
│  │  (occupied by another account)             │ │
│  │                                            │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
└──────────────────────────────────────────────────┘
```

**New Elements:**
- **Account Label**: Shows "Logged in as: [username]" at top (12pt font)
- **Logout Button**: Returns user to login screen (30px height)
- **Account Info**: Clearly identifies who is logged in

**Slot Types:**
1. **Empty Slot**: Shows "Slot X - Empty" with "Create Character" button
2. **Your Character**: Shows full character info with "Play" and "Delete" buttons
3. **Unavailable Slot**: Shows "Slot X - Unavailable" (occupied by another account)

**Character Info Display:**
- Character name (20pt font, bold)
- Total level and XP (12pt font, gray)
- Created date (10pt font, lighter gray)
- Last played date (10pt font, lighter gray)
- Play button (100px wide, 40px height)
- Delete button (100px wide, 40px height, red text)

## 3. User Flow Diagrams

### New User Journey
```
Start Game
    ↓
Login Screen
    ↓
Click "Create Account"
    ↓
Create Account Form
    ↓
Enter username (min 3 chars)
Enter password (min 6 chars)
Confirm password
    ↓
Click "Create Account"
    ↓
[Validation]
    ↓
Auto-login
    ↓
Character Selection Screen
    ↓
Click "Create Character" on empty slot
    ↓
Enter character name
    ↓
Character created and linked to account
    ↓
Click "Play"
    ↓
Main Game
```

### Returning User Journey
```
Start Game
    ↓
Login Screen
    ↓
Enter username
Enter password
    ↓
Click "Login" (or press Enter)
    ↓
[Authentication]
    ↓
Character Selection Screen
(Shows only their characters)
    ↓
Click "Play" on existing character
    ↓
Main Game
```

### Logout Flow
```
Character Selection Screen
    ↓
Click "Logout" button
    ↓
Login Screen
(Must login again to access characters)
```

## 4. Visual Design Choices

### Colors
- **Background**: Dark blue-gray (#1F232E / RGB 31, 35, 46)
- **Text**: White/light gray for primary content
- **Error Text**: Red/coral (#E64D4D / RGB 230, 77, 77)
- **Empty Slot Text**: Medium gray (50% opacity)
- **Unavailable Slot Text**: Medium gray (50% opacity)
- **Stats Text**: Light gray (70% opacity)
- **Delete Button**: Red text (RGB 204, 77, 77)

### Spacing
- Top margin: 40px
- Between sections: 20px
- Between inputs: 10px
- Panel padding: Consistent with existing design
- Minimum button height: 30-50px for touch-friendly interface

### Typography
- Title: 36pt (SkillForge Idle)
- Subtitle: 24pt (Login/Create Account)
- Section headers: 16-20pt
- Body text: 12-14pt
- Small text: 10pt (dates, secondary info)
- Account label: 12pt

### Layout
- **Mobile-first**: 720x1280 viewport
- **Centered panels**: All forms centered on screen
- **Fixed panel width**: 500-600px for forms
- **Touch targets**: Minimum 40px height for buttons
- **Clear hierarchy**: Size and spacing guide the eye

## 5. Interaction Details

### Login Screen
- **Focus**: Username field has focus by default
- **Tab Order**: Username → Password → Login button
- **Enter Key**: Submits login form
- **Password Field**: Shows dots instead of characters
- **Error Display**: Red text appears below password field
- **Button States**: Standard hover/press states

### Create Account Screen
- **Focus**: Username field has focus when shown
- **Tab Order**: Username → Password → Confirm → Create button
- **Enter Key**: Submits create account form
- **All Password Fields**: Show dots instead of characters
- **Validation**: Real-time error messages
- **Password Mismatch**: Clear error when confirmation doesn't match

### Character Selection Screen
- **Account Display**: Always visible at top
- **Logout Button**: Prominent but not intrusive
- **Character Slots**: Clear visual distinction between states
- **Create Dialog**: Modal overlay for character creation
- **Delete Confirmation**: Modal dialog with clear warning
- **Touch Friendly**: Large buttons for mobile interaction

## 6. Accessibility Features

- Large touch targets (minimum 40px height)
- Clear visual hierarchy
- High contrast text
- Error messages are descriptive
- Keyboard navigation supported
- Enter key works for form submission
- Virtual keyboard enabled on mobile

## 7. Security Visual Indicators

- **Password Fields**: Always show as secret (dots)
- **No Password Display**: Never show plain text passwords
- **Error Messages**: Generic for login ("Invalid username or password")
- **Unavailable Slots**: Don't reveal details about other users
- **Account Info**: Only shows your own username

## 8. Mobile Considerations

- **Portrait Mode**: 720x1280 optimized layout
- **Touch Targets**: All buttons 40px+ height
- **Virtual Keyboard**: Enabled for all text inputs
- **Scrolling**: Not needed on login/create screens
- **Clear Buttons**: Large, easy to tap
- **No Hover States**: Focus on tap interactions
