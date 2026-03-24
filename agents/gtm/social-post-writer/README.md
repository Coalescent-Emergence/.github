# Social Post Writer Agent

## Purpose

Generate sets of LinkedIn/Facebook post drafts in the founder's voice. Outputs are drafts for human review — nothing is published without explicit human approval.

## Scope

Currently scoped to Kerrigan GTM content. Loads Kerrigan product context docs at runtime. Not a generic social media agent.

## Trigger

- **Manual only**: Open `social-post-writer-prompt.md` in Copilot chat. Invoke with a generation command. See Invocation below.

## Hierarchy Position

Standalone agent. No upstream router. Does not route to troubleshooting or lifecycle agents.

Downstream handoff available to: `kerrigan-experiment-log` (advisory — propose new EXP entries only, never edit directly).

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `mode` | yes | `set` (5 posts) or `single` (1 post) |
| `set_id` | yes | e.g. `SET-002` — next ID from `social/README.md` Set Index |
| `context` | no | Pasted URL or short note for timely hook; omit to draw from product docs only |

## Outputs

Structured output per invocation:

1. **Set manifest** — arc summary, 5 post slots with archetype + filename
2. **Per-post file content** — ready to save as individual files in `social/YYYY-MM/`
3. **Confidence + review block** — includes any claims requiring human verification and proposed experiment log additions

## Context Docs to Load Before Invocation

Load in this order. All paths relative to `mvp-control-plane/docs/`:

1. `product/kerrigan/kerrigan_product_spec.md`
2. `product/kerrigan/kerrigan_customer_research.md`
3. `product/kerrigan/kerrigan_founder_voice_guide.md`
4. `product/kerrigan/kerrigan_gtm_playbook.md`
5. `product/kerrigan/kerrigan_experiment_log.md`
6. `product/kerrigan/social/README.md`
7. Last 3 post files from `product/kerrigan/social/`

## Invocation

Open `social-post-writer-prompt.md` in Copilot chat with the context docs attached. Then:

```
Generate SET-XXX.
```

or with external context:

```
Generate SET-XXX. Context: [paste URL or short note]
```

## Constraints

- All outputs are drafts — never auto-publish
- Never fabricate pilot data, customer quotes, or outcome metrics
- Never make compliance guarantees ("HIPAA-compliant", "fully compliant", "guaranteed secure")
- A5 (social_proof) and A6 (product_demo) archetypes are locked until pilot data exists
- Propose experiment log additions only — never edit the log directly

## Kerrigan-Specific Archetype Note

- `A1 / origin_story` is not required to be autobiographical. For Kerrigan, it can be a design-origin post: the constraint, boundary, or product thesis that led to the build.
- Prefer design-origin over personal-history framing when the founder's actual approach was first-principles product design rather than a single life-story trigger.
- Use the founder voice guide as a hard constraint. Default to paragraph-based argument, not line-broken engagement prose.

## Schema

See `social-post-writer-schema.json` for full input/output contract.

## Related

- Context doc: `mvp-control-plane/docs/product/kerrigan/kerrigan_social_post_agent.md`
- Post index: `mvp-control-plane/docs/product/kerrigan/social/README.md`
- Experiment log: `mvp-control-plane/docs/product/kerrigan/kerrigan_experiment_log.md`
- Shared handoff: `agents/_shared/project-handoff-protocol.md`
