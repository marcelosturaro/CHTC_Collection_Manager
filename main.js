const { app, BrowserWindow, ipcMain, dialog, shell } = require('electron');
const fs = require('fs'), path = require('path');
const D = () => app.getPath('userData');

ipcMain.handle('read', (e, n) => { const p = path.join(D(), n); return fs.existsSync(p) ? fs.readFileSync(p, 'utf8') : null; });
ipcMain.handle('write', (e, n, t) => {
  const p = path.join(D(), n);
  if (fs.existsSync(p)) fs.copyFileSync(p, p + '.bak');   // automatic safety copy
  fs.writeFileSync(p, t); return p;
});
ipcMain.handle('cloudRead', (e, f, n) => { const p = path.join(f, n); return fs.existsSync(p) ? fs.readFileSync(p, 'utf8') : null; });
ipcMain.handle('cloudWrite', (e, f, n, t) => { const p = path.join(f, n); fs.writeFileSync(p + '.tmp', t); fs.renameSync(p + '.tmp', p); });
ipcMain.handle('pickFolder', async () => {
  const r = await dialog.showOpenDialog({ properties: ['openDirectory', 'createDirectory'] });
  return r.canceled ? null : r.filePaths[0];
});
ipcMain.handle('dataPath', () => D());

function createWindow() {
  const win = new BrowserWindow({
    width: 1380, height: 880, minWidth: 1000, minHeight: 640,
    title: 'CHTC Collection Manager', icon: path.join(__dirname, 'build', 'icon.png'),
    webPreferences: { preload: path.join(__dirname, 'preload.js'), contextIsolation: true }
  });
  win.setMenuBarVisibility(false);
  win.loadFile('index.html');
  win.webContents.setWindowOpenHandler(({ url }) => { shell.openExternal(url); return { action: 'deny' }; });
}
app.whenReady().then(createWindow);
app.on('window-all-closed', () => { if (process.platform !== 'darwin') app.quit(); });
app.on('activate', () => { if (BrowserWindow.getAllWindows().length === 0) createWindow(); });
