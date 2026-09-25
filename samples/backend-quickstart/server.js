// Sample partner backend for the Visualize SDK — plain Node, no dependencies.
//
// Three jobs, the only three a partner backend has:
//   1. POST /session               — mint a session token for your app
//   2. POST /webhooks/visualize    — receive signed scan events
//   3. DELETE /members/:ref/results — forward a member's deletion request
//
// Configuration is environment variables; nothing secret lives in this file.

const crypto = require("node:crypto");
const http = require("node:http");

const PORT = process.env.PORT || 8080;
const VISUALIZE_API = process.env.VISUALIZE_API || "https://api.visualizeme.ai";
const SECRET_KEY = process.env.VISUALIZE_SECRET_KEY; // sk_live_... or sk_test_...
const WEBHOOK_SECRET = process.env.VISUALIZE_WEBHOOK_SECRET; // whsec_..., optional until you set a webhook URL

if (!SECRET_KEY) {
  console.error("Set VISUALIZE_SECRET_KEY (your sk_... from the portal).");
  process.exit(1);
}

// Webhook delivery is at-least-once: remember what we've already handled.
// In production, use your database instead of process memory.
const seenEvents = new Set();

const server = http.createServer(async (req, res) => {
  try {
    // 1. Your app calls this to start a scan. In production, authenticate
    //    the member first — the ID you pass as host_user_ref is who gets
    //    scanned AND who gets billed.
    if (req.method === "POST" && req.url === "/session") {
      // ⚠️ host_user_ref — WHO is scanned, and WHO is billed.
      // Visualize bills per distinct host_user_ref per month (a "monthly
      // active scanning user"). So this MUST be YOUR stable ID for the
      // signed-in member, chosen by YOUR server from its own authentication
      // — never taken from the app, which can't be trusted to say who it is.
      // Use the same value every time for the same person, across devices.
      // Hardcoded for the sample; override with MEMBER_REF to test more.
      const memberId = process.env.MEMBER_REF || "member_demo_1";
      const minted = await fetch(`${VISUALIZE_API}/v1/sessions`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${SECRET_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ host_user_ref: memberId }),
      });
      const body = await minted.text();
      res.writeHead(minted.status, { "Content-Type": "application/json" });
      return res.end(body);
    }

    // 2. Visualize calls this after every scan. Verify the signature over
    //    the RAW bytes before parsing, and dedupe on the event ID.
    if (req.method === "POST" && req.url === "/webhooks/visualize") {
      const raw = await readBody(req);

      if (WEBHOOK_SECRET) {
        const expected = crypto
          .createHmac("sha256", WEBHOOK_SECRET)
          .update(raw)
          .digest();
        const given = Buffer.from(
          req.headers["visualize-signature"] || "",
          "hex",
        );
        const ok =
          given.length === expected.length &&
          crypto.timingSafeEqual(given, expected);
        if (!ok) {
          res.writeHead(400);
          return res.end("bad signature");
        }
      }

      const eventId = req.headers["visualize-event-id"] || "";
      if (seenEvents.has(eventId)) {
        res.writeHead(200); // acknowledged before — nothing new to do
        return res.end();
      }
      seenEvents.add(eventId);

      const event = JSON.parse(raw);
      if (event.type === "scan.completed") {
        console.log(`scan.completed  ${event.data.scan_id}  member ${event.data.host_user_ref}`);
      }
      if (event.type === "scan.results_available") {
        // Only arrives if you enabled results delivery in the portal.
        // No database here — a real backend would store event.data.result.
        console.log(`scan.results_available  member ${event.data.host_user_ref}:`);
        console.log(JSON.stringify(event.data.result, null, 2));
      }
      res.writeHead(200);
      return res.end();
    }

    // 3. A member asked you to delete their data (results delivery only).
    const deletion = req.url.match(/^\/members\/([^/]+)\/results$/);
    if (req.method === "DELETE" && deletion) {
      const ref = encodeURIComponent(decodeURIComponent(deletion[1]));
      const deleted = await fetch(
        `${VISUALIZE_API}/v1/results?host_user_ref=${ref}`,
        { method: "DELETE", headers: { Authorization: `Bearer ${SECRET_KEY}` } },
      );
      const body = await deleted.text();
      res.writeHead(deleted.status, { "Content-Type": "application/json" });
      return res.end(body);
    }

    res.writeHead(404);
    res.end();
  } catch (error) {
    console.error(error);
    res.writeHead(500);
    res.end();
  }
});

function readBody(req) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    req.on("data", (c) => chunks.push(c));
    req.on("end", () => resolve(Buffer.concat(chunks)));
    req.on("error", reject);
  });
}

server.listen(PORT, () => {
  console.log(`partner backend on :${PORT} -> ${VISUALIZE_API}`);
});
