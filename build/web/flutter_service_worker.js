'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "a3926100d9b54743af402a6aa3c21b85",
"assets/AssetManifest.bin.json": "5165f7c47c4623b4d4e2e3eb232febd8",
"assets/AssetManifest.json": "cd9ee470a916e1df459ad8bd7b6d6782",
"assets/assets/audio/check.mp3": "831ed18513fbef0149ae81b448c47d4c",
"assets/assets/audio/error.mp3": "5569d9e8c8b308482db1dad3b735aff8",
"assets/assets/audio/report.mp3": "7dee73cc5c35a6bb8e534f6e6548046d",
"assets/assets/audio/wrong.mp3": "d5858d835dbabb5ee7cbb2645fdc199c",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "755103676870bc97913a15e0735da0b8",
"assets/NOTICES": "d0365fc2cb682bfb18306e52c31ffb9c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "c28258a333ec8e53a688ad074fd53c9c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "15c743b5dccf86e37b7f55428375c570",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "140705753e74d9cef7c7233ed889fc22",
"assets/packages/sign_in_button/assets/logos/2.0x/facebook_new.png": "dd8e500c6d946b0f7c24eb8b94b1ea8c",
"assets/packages/sign_in_button/assets/logos/2.0x/google_dark.png": "68d675bc88e8b2a9079fdfb632a974aa",
"assets/packages/sign_in_button/assets/logos/2.0x/google_light.png": "1f00e2bbc0c16b9e956bafeddebe7bf2",
"assets/packages/sign_in_button/assets/logos/3.0x/facebook_new.png": "689ce8e0056bb542425547325ce690ba",
"assets/packages/sign_in_button/assets/logos/3.0x/google_dark.png": "c75b35db06cb33eb7c52af696026d299",
"assets/packages/sign_in_button/assets/logos/3.0x/google_light.png": "3aeb09c8261211cfc16ac080a555c43c",
"assets/packages/sign_in_button/assets/logos/facebook_new.png": "93cb650d10a738a579b093556d4341be",
"assets/packages/sign_in_button/assets/logos/google_dark.png": "d18b748c2edbc5c4e3bc221a1ec64438",
"assets/packages/sign_in_button/assets/logos/google_light.png": "f71e2d0b0a2bc7d1d8ab757194a02cac",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "96a2637cc2355f656808a21e5deef05f",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"icons/android-icon-144x144.png": "108a9b6c3a3c35ae43d2c4978d6b6d18",
"icons/android-icon-192x192.png": "541a4c8c00f65a5d8297e2b2c2f0a6ea",
"icons/android-icon-36x36.png": "b6ff08f6a2158946b40a2d2a0f032508",
"icons/android-icon-48x48.png": "c36787798af063f437e90ff4a007e650",
"icons/android-icon-72x72.png": "f710f7a6df86f8f8cca29e1341d4c156",
"icons/android-icon-96x96.png": "ef2f1e18e183697dd32369a1ddab5916",
"icons/apple-icon-114x114.png": "34f7911e1210e46f7a60168d1be1a711",
"icons/apple-icon-120x120.png": "e1069a6fef24c1e9bbef396d02763c81",
"icons/apple-icon-144x144.png": "108a9b6c3a3c35ae43d2c4978d6b6d18",
"icons/apple-icon-152x152.png": "43fc5a268f61f1bb48585b0080f91ae5",
"icons/apple-icon-180x180.png": "79fe7930538e9b056c4d4fbef6ddb3e5",
"icons/apple-icon-57x57.png": "7e5341001858e0f926decdd450d9852b",
"icons/apple-icon-60x60.png": "7147077a08861d03297d4e1d602a6b81",
"icons/apple-icon-72x72.png": "f710f7a6df86f8f8cca29e1341d4c156",
"icons/apple-icon-76x76.png": "07491d0e195cb54f83f3f6cec4cd8cc2",
"icons/apple-icon-precomposed.png": "805c7cf6196decee310257dcefd4d657",
"icons/apple-icon.png": "805c7cf6196decee310257dcefd4d657",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/favicon-16x16.png": "03432e972115b4590730eba1bfafc66d",
"icons/favicon-32x32.png": "3a3b20ca3e8508f3fa5ba0fcc9d20905",
"icons/favicon-96x96.png": "ef2f1e18e183697dd32369a1ddab5916",
"icons/favicon.ico": "cb4f1b18481c37415feb6b9b1ae6593d",
"icons/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/ms-icon-144x144.png": "108a9b6c3a3c35ae43d2c4978d6b6d18",
"icons/ms-icon-150x150.png": "01c1acc5d81a245aef4bfc892e6a043a",
"icons/ms-icon-310x310.png": "2363c1a09d3abf9b8273f2e319d14b19",
"icons/ms-icon-70x70.png": "d7679876cc043b5dfa81c00010b9d5c5",
"index.html": "24d841290f5c843ddc8cc5cbb6bcbeba",
"/": "24d841290f5c843ddc8cc5cbb6bcbeba",
"logo.png": "96a2637cc2355f656808a21e5deef05f",
"main.dart.js": "fc485c4db3c93430abf6ef9645794d78",
"manifest.json": "16717dc3d8c6d90a273463ec2317b1fb",
"version.json": "20581b6b3178f29638cf2fa96872b22e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
