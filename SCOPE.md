# Scope Register

## Explicitly out of scope

The following features must not be added unless the PRD is amended:

- Pharmacy integration
- Insurance claims
- Telemedicine
- Laboratory information-system integration
- SMS gateway
- Billing, payment processing, invoicing, receipts, and cashier roles — the clinic's external POS owns these. A treatment docket QR hands treatment data to that POS; this system must never represent the POS as an in-system billing module
- Online payment gateway
- Dedicated mobile application
- Multi-branch synchronization

These are documented future enhancements only. They must not be represented by operational-looking buttons or disconnected placeholder pages. In particular, no Billing or payment workspace, payment form, receipt dialog, or Cashier role may be reintroduced: they would duplicate records the external POS already owns. A Sales Management report is in scope only as a service-sales view read from treatment dockets — it shows the service and the quantity sold, and carries no price, payment, receipt, refund or paid-status information.

## Scope rule

If a request is outside the approved PRD and outside the supported clinic workflows, ask for clarification or record it here as a future enhancement. Do not silently expand the system scope.
