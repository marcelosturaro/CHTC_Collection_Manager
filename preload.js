const { contextBridge, ipcRenderer } = require('electron');
const i = (c) => (...a) => ipcRenderer.invoke(c, ...a);
contextBridge.exposeInMainWorld('api', {
  read: i('read'), write: i('write'), cloudRead: i('cloudRead'),
  cloudWrite: i('cloudWrite'), pickFolder: i('pickFolder'), dataPath: i('dataPath')
});
