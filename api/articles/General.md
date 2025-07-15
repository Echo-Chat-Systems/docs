# Definitons

This folder contains the concrete definitions for all transmitted entities in Echo. 

## Preface

All API communications are done through websockets, in which a connection is obtained at /v1/ws. 

## Rules

For consistentcy sake, several thoroughly enforced rules are present throughout each definition. They are listed in the following sections. 

### 1. Signed Data

Any signed data must be entirely contained under the key *`package`*, with the signature being under the key *`sig`* key. 