# ⚠️ RESTART REQUIRED

## Why Am I Still Getting CSP Errors?

### The Problem
You're seeing this error:
```
Connecting to 'http://localhost:3000/api/v1/auth/register' violates the following 
Content Security Policy directive: "default-src 'self'"
```

### The Solution: RESTART YOUR SERVER! 🔄

**Rails initializers** (files in `config/initializers/`) are **only loaded when the server starts**.

Any changes to these files require a server restart:
- ✅ `config/initializers/content_security_policy.rb` - CSP configuration
- ✅ `config/initializers/rswag_ui.rb` - Swagger UI configuration
- ✅ `config/initializers/devise.rb` - Authentication configuration

---

## 🚀 HOW TO RESTART

### Step 1: Stop the Server
In your terminal where Rails is running:
```bash
# Press Ctrl+C to stop the server
```

### Step 2: Start the Server Again
```bash
rails server
```

### Step 3: Hard Refresh Your Browser
```bash
# Mac: Cmd + Shift + R
# Windows/Linux: Ctrl + Shift + R
```

### Step 4: Test Swagger UI
```
http://localhost:3000/api-docs
```

---

## ✅ What Should Work After Restart

1. **No CSP Errors** ✅
   - API calls from Swagger UI will work
   - No "violates Content Security Policy" errors

2. **Correct Tag Order** ✅
   - Users section at the top
   - No alphabetical sorting

3. **No Tag Filter** ✅
   - Clean UI without filter box

4. **Standings Visible** ✅
   - Standings endpoint appears in documentation

---

## 🔍 Verify CSP is Working

After restarting, open browser console (F12) and check:

### Before Restart (Current Issue):
```
❌ CSP Error: default-src 'self' blocks localhost:3000
```

### After Restart (Should Work):
```
✅ No CSP errors
✅ Swagger UI can make API calls
✅ Request completes successfully
```

---

## 🛠️ If Still Having Issues After Restart

### 1. Verify Server is Using New Configuration
```bash
# Check server output for CSP warnings
# You should NOT see CSP violation errors in server logs
```

### 2. Clear Browser Cache
```bash
# Completely close and reopen browser
# Or use Incognito/Private mode
```

### 3. Check CSP Configuration
The file `config/initializers/content_security_policy.rb` should have:
```ruby
policy.connect_src :self, :https, "http://localhost:3000", "ws://localhost:3000"
```

### 4. Verify Server Port
Make sure the server is running on port 3000:
```bash
rails server
# Should show: Listening on http://127.0.0.1:3000
```

---

## 📝 Quick Checklist

- [ ] Stop Rails server (Ctrl+C)
- [ ] Start Rails server again (`rails server`)
- [ ] Hard refresh browser (Cmd+Shift+R or Ctrl+Shift+R)
- [ ] Clear browser cache if needed
- [ ] Visit `http://localhost:3000/api-docs`
- [ ] Open browser console (F12) to check for errors
- [ ] Try an API endpoint from Swagger UI

---

## 💡 Remember

**Initializer changes = Server restart required!**

This is a one-time thing. After you restart the server, the CSP configuration will be loaded and all Swagger UI functionality will work perfectly!

---

## ✅ Expected Result After Restart

```
🎉 SUCCESS!

✅ Swagger UI loads at http://localhost:3000/api-docs
✅ No CSP errors in browser console
✅ Can test API endpoints directly from Swagger UI
✅ Tags appear in correct order (Users first)
✅ No filter box visible
✅ Standings endpoint is visible

Ready to test your API! 🚀
```

