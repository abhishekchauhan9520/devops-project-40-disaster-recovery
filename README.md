# Project 40 — Automated Disaster Recovery Platform

A guarded disaster-recovery workflow that demonstrates backup, restore verification, recovery-point tracking, failover controls, and post-recovery validation.

## Architecture

```text
Primary workload
      |
      +--> periodic backup --> durable backup store
      |                         |
      |                         +--> checksum / manifest
      |
      +--> health monitoring
                 |
                 v
          Recovery controller
             /          \
            /            \
       restore test     failover gate
            |                |
            v                v
     isolated recovery   secondary target
            |                |
            +-------> verification
                         |
                         v
                  recovery report
```

## Capabilities

- Versioned application/data backups
- Checksum and manifest verification
- Restore into an isolated recovery environment
- Recovery point and recovery time measurement
- Recovery readiness report
- Guarded failover procedure
- Explicit operator confirmation before traffic-changing actions
- Post-failover health checks
- Recovery audit trail
- Scheduled CI validation without touching external infrastructure

## Safety model

The repository never performs an external failover during CI. Destructive or traffic-changing operations require explicit confirmation and are separated from backup/restore verification.

## Local simulation

The `scripts/` workflow can simulate:

1. primary data generation
2. backup creation
3. checksum validation
4. restore into a clean recovery directory
5. recovery verification
6. simulated failover
7. report generation

The simulation uses the local filesystem and does not create cloud resources.

## Production mapping

The same control-plane pattern can be adapted to:

- AWS: S3 versioned backups, RDS snapshots, Route 53 failover, cross-region infrastructure
- Azure: Blob Storage, Azure Database backups, Traffic Manager/Front Door
- GCP: Cloud Storage, Cloud SQL backups, Cloud DNS/Global Load Balancing
- Kubernetes: Velero-style cluster backup/restore and GitOps-based secondary-cluster promotion

## Recovery objectives

Document target values per workload:

- **RPO** — maximum acceptable data loss window
- **RTO** — maximum acceptable time to restore service

The repository reports measured recovery values during the simulation.

## Validation

```bash
./scripts/run-dr-test.sh
```

A real cross-region failover requires an external cloud or multi-cluster environment and is intentionally not executed by CI.

## License

MIT
