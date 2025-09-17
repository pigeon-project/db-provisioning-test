# Product Overview

**What:** Kanban-style task manager with **boards → columns → cards** and board-level sharing (roles).

**Who:** Individuals, teams, managers.

**Core value:** fast planning, flexible drag ordering, precise sharing, instant collaboration.

## Functional Requirements (Product-Level)

### 1. Authentication & Access Control
- Only authenticated users can access any board-related content.
- Access to a board is granted through ownership, invitation acceptance, or existing membership.
- Role-based permissions determine what actions a user sees in the UI (no hidden destructive actions for unauthorized roles).
- The product must prevent removing or downgrading the final remaining admin of a board.
- Users must not be able to access content from boards they are not a member of.

### 2. Boards
- Users can create boards by providing a human-readable name (short, recognizable) and an optional description.
- Users can view a list of boards they belong to; the list supports efficient navigation for large numbers of boards.
- A board view shows its structure: columns (in order) and their cards.
- Board owners/admins can rename or update descriptive text.
- Admins can permanently delete a board; deletion also removes all dependent content (columns, cards, memberships, invitations).
- Board content must remain immediately usable after creation (no delayed provisioning).

### 3. Columns (Lists)
- Admins and writers can add new columns to organize work stages.
- Columns can be renamed.
- Columns can be repositioned within the board by drag & drop or accessibility controls.
- Deleting a column removes all cards it contains (with clear confirmation in the UI).
- The system preserves intended column order reliably across sessions and users.

### 4. Cards (Tasks)
- Admins and writers can create cards with a concise title and optional longer description.
- Cards can be edited (title and description).
- Cards can be moved within a column or to another column in the same board.
- A move updates only the moved card; other positions remain stable.
- Cards can be deleted by authorized users.
- Readers can view but never modify cards.

### 5. Ordering & Prioritization
- Users can reorder columns and cards fluidly (e.g., prioritizing tasks).
- Reordering must appear instantly to the initiating user and propagate quickly to other viewers.
- A consistent and deterministic ordering is always presented (no flicker or unstable positions).
- Large numbers of reorder operations should not degrade experience (no “rebuild all” style operations from the user’s perspective).
- Accessibility alternatives (keyboard actions) must allow the same ordering control as drag & drop.

### 6. Membership & Collaboration
- Any existing board member can view the list of current members and their roles.
- Admins can invite a user (by email or internal identifier) and assign an initial role.
- Pending invitations are represented until accepted.
- Invitees can accept and immediately gain the assigned role.
- Admins can change a member’s role (with last-admin protection).
- Admins can remove a member, except the last remaining admin.
- A non-admin member can voluntarily leave a board unless they are the last admin.
- Presence of multiple roles supports future reporting or filtered experiences.

### 7. Ownership Transfer & Governance
- The current owner can transfer ownership to another existing member.
- After transfer, the new owner gains full ownership rights; the former owner remains an admin (unless later changed).
- Ownership transfer is auditable (traceable in activity history—future enhancement).

### 8. Access & Visibility
- Users only see boards they are a member of (no “guessable” discovery).
- Email addresses or personally sensitive membership data may be selectively redacted for users without elevated rights (privacy mode).
- Readers must not see administrative affordances (invite, role change, delete board).

### 9. User Experience
- Core interactions (create, edit, move, reorder) should feel immediate (optimistic state where safe).
- Error states provide actionable guidance (e.g., cannot move card across boards).
- The interface remains navigable and performant even with boards approaching soft recommended size thresholds.
- High-frequency reorder activity should not cause UI lag or force manual refreshes.

### 10. Constraints & Governance (Product Perspective)
- Soft advisory limits guide healthy usage (e.g., practical caps on columns and cards per board) with clear messaging when exceeded.
- Attempts to exceed soft limits result in user-visible guidance (encourage cleanup or segmentation into new boards).
- Cross-board card moves are intentionally disallowed to preserve contextual integrity; future cross-board linking may be introduced.

### 11. Future Extensions (Non-Commitment)
- Potential additions: card labels/tags, attachments, due dates, activity log, bulk actions, archived columns/cards.
- Architecture and data representation should not preclude these evolutions.
- Ordering mechanism must scale to additional dimensions (e.g., swimlanes) without wholesale recompute.

## Non-Functional Requirements (Reference)
This product relies on the shared organization-wide Non-Functional Requirements: [Shared NFR](SHARED-NFR.md)

### Product-Level Emphasis (No Technical Detail)
- Reliability: Users should never experience ambiguous ordering or “lost” cards after a move.
- Usability: Reordering and membership changes reflect across active sessions with minimal perceptible delay.
- Performance: Large boards remain responsive for scrolling and drag interactions.
- Privacy: Member identity exposure aligns with role-based visibility rules.
- Accessibility: All ordering and movement functions have keyboard-accessible paths.
- Governance: Ownership transfer and role changes avoid accidental lock-out of administration.

## Database Specification

### Database Engine
- **Selected Engine:** PostgreSQL 16

### Sizing & Performance Requirements
- **Estimated DB Size (Year 1):** 20 GB
- **Estimated DB Size (Year 3):** 100 GB
- **Average Write RPS:** 50 writes per second
- **Peak Write RPS:** 200 writes per second
- **Average Read RPS:** 500 reads per second
- **Peak Read RPS:** 2000 reads per second
- **p99 Latency Target:** < 100ms for reads, < 200ms for writes
- **Max Concurrent Connections:** 500

### Business Continuity
- **Recovery Time Objective (RTO):** 4 Hours
- **Recovery Point Objective (RPO):** 1 Hour
- **Backup Policy:** Automated daily snapshots with Point-in-Time Recovery (PITR) enabled.
- **Retention Policy:** Snapshots retained for 35 days.

### Proposed Provisioning Configuration (Initial Setup)
- **Cloud Provider:** AWS RDS
- **Instance Class:** db.m6g.large
- **Storage:** 150 GB Provisioned IOPS SSD (io2)
- **High Availability:** Multi-AZ Standby
- **Read Replicas:** 1 replica
- **Sharding Strategy:** Not required at initial scale.

## Assumptions and Justifications

* **Database Selection:** PostgreSQL chosen for its strong ACID compliance, relational model suitability, reliable ordering, and robust concurrency controls which align with the application requirements of precise ordering and complex role-based access control.
* **Peak RPS Calculation:** Estimated based on a user base growing to tens of thousands, with concurrency assumptions of approximately 10% active users performing board operations, including rapid reorder actions.
* **Database Sizing:** Projected data volume includes metadata for boards, columns, cards, memberships, and roles. Estimated growth assumes increasing user and board counts with moderate data retention.
* **RTO/RPO Values:** Industry-standard defaults for collaborative SaaS applications, balancing business continuity costs and user experience.
* **Instance Class Selection:** db.m6g.large supports the expected workload with balanced vCPU and RAM, appropriate for the expected read/write RPS and concurrency requirements, and supports Multi-AZ for availability.


