# Before & After Examples

This document demonstrates how the `evidence-aware-reasoning` skill transforms agent responses when evaluating unverified premises, high-stakes decisions, or ambiguous input.

---

## Scenario 1: Unverified User Assumption in Security / Architecture

### User Prompt
> "Our database latency spiked because the new indexing strategy failed. Should we roll back immediately?"

### Without Skill ❌ (Escalating Assumption to Fact)
> "Yes, since the new indexing strategy failed and caused the latency spike, you should perform an immediate rollback. Here are the steps to roll back your database indexes..."
>
> *(Issue: Accepts the user's premise as fact without checking if the index actually caused the spike).*

### With `evidence-aware-reasoning` Skill ✅ (Distinguishing Evidence from Premise)
> "If the new indexing strategy is indeed the cause of the latency spike, rolling back is a sound option. However, before executing a rollback, let's verify the evidence:
> 
> 1. **Verified Evidence**: We know database latency has spiked.
> 2. **Unverified Premise**: The spike was caused by the recent indexing change.
> 3. **Alternative Possibilities**: Connection pool exhaustion, lock contention, or concurrent batch jobs.
> 
> **Recommended Next Step**: Check query execution plans and database slow-query logs to confirm whether the new index is being used inefficiently before rolling back."

---

## Scenario 2: Strategic / Product Decision under Uncertainty

### User Prompt
> "Users are dropping off at checkout because our payment gateway is too slow. What should we do?"

### Without Skill ❌ (Premise Amplification)
> "To fix the checkout drop-off caused by payment gateway slowness, you should migrate to Stripe or PayPal immediately. Here is a plan to switch providers..."

### With `evidence-aware-reasoning` Skill ✅ (Calibrated Skepticism & Missing Evidence)
> "**Premise Analysis**: Drop-offs are attributed to payment gateway latency.
> 
> **Conditional Evaluation**: *If* telemetry shows that payment API call response times correlate directly with abandoned sessions, upgrading or switching gateways is justified.
> 
> **Missing Evidence**:
> - Client-side telemetry (e.g., UI freeze vs. network response time).
> - Drop-off rates per payment method.
> 
> **Recommendation**: Verify network timing logs on checkout requests before committing to a gateway migration."

---

## Scenario 3: Hypothetical Analysis

### User Prompt
> "Assuming our competitor releases feature X next month, how will our market share decline?"

### Without Skill ❌ (Certainty Inflation)
> "When competitor X releases feature X next month, your market share will drop by 15-20% because customers will migrate for feature X..."

### With `evidence-aware-reasoning` Skill ✅ (Preserving Conditionality)
> "**Conditional Analysis**: *If* your competitor releases feature X next month and *if* that feature directly addresses a core pain point of your existing customer base:
> 
> - **Potential Impact**: Market share *may* experience pressure, particularly among users prioritized around feature X.
> - **Uncertainties**: Actual release timeline, feature quality, pricing changes, and customer switching costs.
> - **Action**: Identify which customer segments rely most on feature X to assess true exposure."
