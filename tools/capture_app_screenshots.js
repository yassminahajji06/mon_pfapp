const fs = require('fs');
const http = require('http');
const path = require('path');
const { spawn } = require('child_process');

const chromePath = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const port = 9223;
const root = path.resolve(__dirname, '..');
const outDir = path.join(root, 'docs', 'tutorial', 'assets', 'screenshots');
const url = 'http://localhost:57321';

fs.mkdirSync(outDir, { recursive: true });

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function getJson(targetUrl) {
  return new Promise((resolve, reject) => {
    http
      .get(targetUrl, (res) => {
        let body = '';
        res.on('data', (chunk) => (body += chunk));
        res.on('end', () => {
          try {
            resolve(JSON.parse(body));
          } catch (error) {
            reject(error);
          }
        });
      })
      .on('error', reject);
  });
}

async function waitForDebugger() {
  for (let i = 0; i < 40; i++) {
    try {
      const pages = await getJson(`http://127.0.0.1:${port}/json/list`);
      const page = pages.find((item) => item.type === 'page');
      if (page?.webSocketDebuggerUrl) return page.webSocketDebuggerUrl;
    } catch (_) {
      // Chrome is still starting.
    }
    await sleep(500);
  }
  throw new Error('Chrome DevTools endpoint did not become available.');
}

async function connectCdp(wsUrl) {
  const socket = new WebSocket(wsUrl);
  let id = 0;
  const pending = new Map();

  await new Promise((resolve, reject) => {
    socket.addEventListener('open', resolve, { once: true });
    socket.addEventListener('error', reject, { once: true });
  });

  socket.addEventListener('message', (event) => {
    const message = JSON.parse(event.data);
    if (message.id && pending.has(message.id)) {
      const { resolve, reject } = pending.get(message.id);
      pending.delete(message.id);
      if (message.error) reject(new Error(message.error.message));
      else resolve(message.result);
    }
  });

  return {
    send(method, params = {}) {
      const messageId = ++id;
      socket.send(JSON.stringify({ id: messageId, method, params }));
      return new Promise((resolve, reject) =>
        pending.set(messageId, { resolve, reject }),
      );
    },
    close() {
      socket.close();
    },
  };
}

async function click(cdp, x, y) {
  await cdp.send('Input.dispatchTouchEvent', {
    type: 'touchStart',
    touchPoints: [{ x, y }],
  });
  await cdp.send('Input.dispatchTouchEvent', {
    type: 'touchEnd',
    touchPoints: [],
  });
  await sleep(250);
  await cdp.send('Input.dispatchMouseEvent', {
    type: 'mousePressed',
    x,
    y,
    button: 'left',
    clickCount: 1,
  });
  await cdp.send('Input.dispatchMouseEvent', {
    type: 'mouseReleased',
    x,
    y,
    button: 'left',
    clickCount: 1,
  });
  await sleep(900);
}

async function wheel(cdp, x, y, deltaY) {
  await cdp.send('Input.dispatchMouseEvent', {
    type: 'mouseWheel',
    x,
    y,
    deltaX: 0,
    deltaY,
  });
  await sleep(800);
}

async function screenshot(cdp, name) {
  const result = await cdp.send('Page.captureScreenshot', {
    format: 'png',
    captureBeyondViewport: false,
  });
  fs.writeFileSync(path.join(outDir, `${name}.png`), result.data, 'base64');
}

async function goHome(cdp) {
  await cdp.send('Page.navigate', { url });
  await sleep(4500);
  await click(cdp, 195, 461);
  await sleep(1000);
}

async function main() {
  const chrome = spawn(chromePath, [
    '--headless=new',
    `--remote-debugging-port=${port}`,
    '--disable-gpu',
    '--no-first-run',
    '--disable-extensions',
    '--user-data-dir=C:/tmp/mon-pfapp-cdp-profile',
    'about:blank',
  ]);

  let cdp;
  try {
    const wsUrl = await waitForDebugger();
    cdp = await connectCdp(wsUrl);
    await cdp.send('Page.enable');
    await cdp.send('Runtime.enable');
    await cdp.send('Emulation.setDeviceMetricsOverride', {
      width: 390,
      height: 844,
      deviceScaleFactor: 2,
      mobile: true,
      screenWidth: 390,
      screenHeight: 844,
    });
    await cdp.send('Page.navigate', { url });
    await sleep(4500);
    await screenshot(cdp, '01-login');

    await click(cdp, 195, 461);
    await sleep(1000);
    await screenshot(cdp, '02-home');

    await click(cdp, 117, 812);
    await screenshot(cdp, '03-menu');

    await click(cdp, 195, 812);
    await screenshot(cdp, '04-cart');

    await click(cdp, 195, 740);
    await screenshot(cdp, '05-tracking');

    await goHome(cdp);
    await click(cdp, 353, 812);
    await screenshot(cdp, '06-profile');

    await goHome(cdp);
    await click(cdp, 353, 812);
    await click(cdp, 195, 664);
    await screenshot(cdp, '07-driver');

    await goHome(cdp);
    await click(cdp, 353, 812);
    await click(cdp, 195, 740);
    await screenshot(cdp, '08-admin');

    console.log(`Screenshots saved to ${outDir}`);
  } finally {
    if (cdp) cdp.close();
    chrome.kill();
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
