# Hospital System Integration

## Overview

This app is designed to integrate with hospital information systems rather than manage patient and staff data directly. In the current demo version, sample data is created within the app, but in a production environment, this data would be pulled from hospital systems.

## Integration Points

### Patient Data
- Source: Hospital EHR/HIS system
- Protocol: FHIR or HL7
- Endpoint: `/api/patients`
- Authentication: OAuth 2.0 with hospital credentials

### Staff Data
- Source: Hospital HR/Credential system
- Protocol: FHIR or REST API
- Endpoint: `/api/staff`
- Authentication: OAuth 2.0 with hospital credentials

### Clinical Data
- Source: Hospital EHR and LIS
- Protocol: FHIR or HL7
- Endpoints: 
  - `/api/observations` (for vital signs)
  - `/api/lab-results`
  - `/api/medications`
- Authentication: OAuth 2.0 with hospital credentials

## Implementation Plan

1. Replace the `DemoDataManager` with an `IntegrationManager` that handles API calls
2. Implement FHIR/HL7 parsers to convert hospital data to app models
3. Add authentication flow for hospital credentials
4. Implement real-time updates using WebSockets or polling

## Demo Mode

The current demo mode creates sample data to demonstrate app functionality without requiring hospital system integration. This allows for development and testing without a live hospital connection.

In production, the `DemoDataManager` would be disabled and the `IntegrationManager` would be used instead. 