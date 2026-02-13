Title: Investigate Microsoft Teams call transcription approaches

Description:
We need to add a feature to transcribe live or recorded Microsoft Teams calls for the MVP. This issue is to research and recommend viable implementation approaches, trade-offs, and a recommended PoC path.

Goals:
- Identify all practical ways to obtain audio (live or recorded) from Teams calls/meetings
- Evaluate integration options (SDKs, APIs, bots, device capture)
- Surface security, compliance, consent and licensing requirements
- Recommend PoC approach and next implementation tasks

Brainstormed approaches (to investigate):
- Capture system audio (bind to audio output device) — brittle, OS/device dependent, works without Teams integration but has many edge cases
- Use Microsoft Teams built-in recording and transcript features — may require tenant settings and access to recordings
- Microsoft Graph Cloud Communications / Calls API (create a bot that joins calls) — supported approach for programmatic call handling
- Microsoft Teams Bot / Meeting participant via Graph + Direct Routing or PSTN — for PSTN calls, compliance recording may be used
- Use the Teams Web Client SDK or WebRTC hooks (if feasible) to capture media from the browser client
- Use Azure Communication Services (ACS) + Speech-to-Text or Azure Speech Services for transcription downstream
- Use third-party transcription integrations (e.g., Rev.ai, AssemblyAI) fed by recordings or live streams

Key considerations:
- Consent and legal requirements for recording/transcribing calls
- Tenant-level admin requirements and permissions (Graph API scopes, application permissions)
- Real-time vs post-call transcription latency and cost
- Reliability: reconnection, dropped audio, multi-party mixing
- Speaker diarization and timestamps accuracy
- Storage, retention, and security of transcripts and recordings

Deliverables for this issue:
1. Short report comparing approaches (pros/cons, needed permissions, cost estimate)
2. Recommended PoC approach (minimal implementation plan)
3. Acceptance criteria for PoC and success metrics

Suggested labels: type:research, area:telephony, effort:small

Requested by: @project
