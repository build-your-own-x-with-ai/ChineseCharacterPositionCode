# Usage Screenshots Guide

## Main Interface

### Code Table Lookup Page

The code table lookup page provides complete GB2312 code table browsing and search functions:

- **Area Selector**: Quickly switch between areas 1-94
- **Search Box**: Enter position codes to search
- **Character Grid**: Display all Chinese characters in card format
- **Character Details**: Tap to view detailed information and copy

### Instructions Page

The instructions page contains:

- **Position Code Introduction**: What is position code and its encoding rules
- **Usage Tutorial**: How to use the keyboard to input Chinese characters
- **Add Keyboard Guide**: Detailed keyboard installation steps
- **Quick Button**: One-click jump to system keyboard settings
- **Common Characters Reference**: Position code distribution explanation

## Keyboard Interface

### Keyboard Layout Explanation

```
┌─────────────────────────┐
│  Position Code: 1601    │  ← Current input position code
│  啊                     │  ← Real-time preview of Chinese character
└─────────────────────────┘
┌───────┬───────┬───────┐
│   1   │   2   │   3   │
├───────┼───────┼───────┤
│   4   │   5   │   6   │
├───────┼───────┼───────┤
│   7   │   8   │   9   │
└───────┴───────┴───────┘
┌─────┬───────┬─────────┬───────┐
│  0  │ Back  │  Space  │ Enter │
└─────┴───────┴─────────┴───────┘
```

### Function Description

1. **Top Display Area**
   - Real-time display of current input position code
   - Shows corresponding character preview when 4 digits are entered

2. **Numeric Keypad Area**
   - Large numeric buttons for easy input
   - Standard 3x3 layout

3. **Function Key Area**
   - **0 Button**: Tap to input digit 0, **Long press (0.5s) to switch keyboard**
   - **Back**: Prioritize deleting input buffer, then delete text
   - **Space**: Input space character
   - **Enter**: Input line break

## Usage Flow Examples

### Example 1: Input "中国" (China)

1. Switch to position code keyboard
2. Enter `3021`
   - Display: Position Code: 3021 → 中
   - Automatically insert "中"
3. Enter `5448`
   - Display: Position Code: 5448 → 国
   - Automatically insert "国"
4. Completed input: "中国"

### Example 2: Input "你好" (Hello)

1. Enter `3694` → 你
2. Enter `2345` → 好
3. Completed input: "你好"

### Example 3: Correction

1. Enter `16`
2. Input error, press "Back" key
3. Position code becomes `1`
4. Continue entering correct digits

## Code Table Lookup Usage

### Search for Specific Characters

1. Open the main App
2. Go to "Code Table" tab
3. Enter position code in search box (e.g., `1601`)
4. View search results
5. Tap character to view details
6. Copy position code or character

### Browse a Specific Area

1. Open code table lookup page
2. Tap the area selector at the top
3. Select the area to browse (e.g., "Area 16")
4. Browse all characters in that area

### Find High-frequency Characters

Common high-frequency characters are mainly in areas 16-55 (Level 1 characters):

- Areas 16-19: a-d pinyin initials
- Areas 20-29: e-l pinyin initials
- Areas 30-39: m-q pinyin initials
- Areas 40-55: r-z pinyin initials

## Settings Guide

### Add Keyboard

1. Open the main App
2. Click the "Instructions" tab
3. Read the "How to Add Keyboard?" section
4. Tap the blue "Open Keyboard Settings" button
5. In the opened system settings page:
   - Go to "Keyboard" settings
   - Tap "Add New Keyboard..."
   - Find "Position Code" in third-party keyboards
   - Tap to add

### Switch Keyboard

In any input field:
- **Long press (0.5s) the "0" button**
- Select "Position Code" from the popup menu

Or use the system globe icon (if you have other keyboards).

## Tips and Suggestions

### Memorize Common Characters

It's recommended to memorize position codes for some high-frequency characters:

- `2136` 的
- `5027` 一
- `4239` 是
- `2934` 人
- `2976` 他

### Find Rare Characters

1. Use the main App's code table lookup
2. Browse by area (areas 56-87 are Level 2 characters)
3. Record position codes for needed characters

### Fast Input

- Master the numeric key positions
- Memorize position codes for common characters
- Utilize real-time preview to confirm input

## Notes

1. **Must enter 4 digits**: Less than 4 digits won't output characters
2. **Position Range**: Both area and position numbers are 01-94
3. **Not all positions have characters**: Some positions are empty
4. **Long Press to Switch**: **Long press (0.5s) the "0" button** to switch keyboard
5. **Short Press to Input**: **Tap the "0" button** to input digit 0

## Troubleshooting

### Keyboard Not Displaying

- Confirm keyboard has been added in system settings
- Try restarting the device
- Reinstall the App

### Unable to Input Characters

- Check if 4 digits have been entered
- Confirm position code is valid (01-94)
- Check code table to confirm character exists at that position

### Preview Not Showing

- Continue typing until 4 digits are entered
- Confirm position code is valid

---

For other issues, please refer to README.md or submit an Issue.