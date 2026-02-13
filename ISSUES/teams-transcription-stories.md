### 📝 Generated Stories (4)

**Confidence**: 84%

#### 1. Bot-based live transcription via Microsoft Graph Calls API

**Complexity**: L

**Acceptance Criteria**:
- A bot service can join a Teams meeting as a participant via Microsoft Graph Cloud Communications and receive mixed audio streams.
- Audio received by the bot is forwarded to an Azure Speech-to-Text pipeline for near real-time transcription.
- Transcripts include timestamps and basic speaker separation (host vs guests) where feasible.
- Transcripts are stored securely in project storage with access controls.

**Dependencies**: Azure AD app registration with appropriate Graph application permissions, Azure Speech resources, hosting for the bot (container), tenant admin consent.

**Test Strategy**: End-to-end integration test where a test meeting is created, bot joins, sample audio played, and resulting transcript is validated for presence and timestamps.

**Suggested Labels**: type:feature, area:telephony, effort:medium

---

#### 2. Post-call transcription using Teams recordings + Graph API

**Complexity**: M

**Acceptance Criteria**:
- Team recordings are accessible via Graph API for meetings in the tenant (recordings retention and permissions configured).
- A worker can fetch recording blobs, run them through Azure Speech (or third-party STT), and produce searchable transcripts with timestamps.
- The system correlates recording metadata to internal meeting IDs and stores transcript alongside the original recording.

**Dependencies**: Tenant recording settings, Graph API access to meeting recordings, storage bucket, STT provider account.

**Test Strategy**: Simulate meeting recording upload, run batch transcription, and verify transcript completeness and storage metadata.

**Suggested Labels**: type:feature, area:telephony, effort:small

---

#### 3. Client-side capture via WebRTC hooks (Web client PoC)

**Complexity**: H

**Acceptance Criteria**:
- A browser-side component is able to capture the mixed audio from the Teams Web client (via injected script or extension) and stream to our backend.
- The captured stream can be transcribed with acceptable latency.
- The approach documents browser compatibility and security implications.

**Dependencies**: Browser extension/inline script permissions, user consent flows, maintenance burden for client updates.

**Test Strategy**: Manual browser PoC with controlled meetings; validate capture fidelity across Chrome/Edge and handling of multiple participants.

**Suggested Labels**: type:spike, area:telephony, effort:large

---

#### 4. Fallback: System audio capture (local client agent)

**Complexity**: M

**Acceptance Criteria**:
- A local agent can capture system output audio reliably on supported OSes and produce WAV/PCM suitable for transcription.
- The agent supports configuring which audio device to capture and can be started/stopped by end users.
- Documentation lists known limitations and supported platforms.

**Dependencies**: Installer for local agent, OS-level audio APIs, user consent.

**Test Strategy**: Run agent on Windows and Mac, play sample calls, compare transcripts to baseline.

**Suggested Labels**: type:feature, area:telephony, effort:medium

---

**Rationale**: For the MVP, a Graph bot-based approach (story 1) offers the most robust path for real-time transcription under tenant-managed permissions and integrates well with Azure Speech. Post-call transcription (story 2) is the lowest-effort fallback where tenant recording is available. Client-side and system-capture approaches are brittle and should be considered only after Graph/recording options are exhausted.

**Next steps / PoC plan**:
1. Run a short spike to confirm Graph Calls API availability in our tenant (bot join) — success criteria: bot can join test meeting and receive audio.
2. Wire received audio to Azure Speech SDK in a simple service and validate transcript quality.
3. Implement storage & access control for transcripts; add consent notice UI in product.
4. If Graph approach blocked by permissions, pivot to post-call transcription using Teams recordings.

**Confidence**: 84%
