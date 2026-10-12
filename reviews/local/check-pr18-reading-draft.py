#!/usr/bin/env python3
"""Validate the candidate packet independently of the adopted registry."""
from pathlib import Path
import hashlib,json,re,subprocess
R=Path(__file__).resolve().parents[2]
D=R/'reviews/local/pr18-reading-draft'
p=json.loads((D/'pr18-source-packet.json').read_text())
assert p['status']=='review-draft-not-adopted'
assert p['proposed_registry']['binding'] is False
seen=set()
for term in p['proposed_registry']['terms']:
 assert term['id'] not in seen
 assert set(term['depends_on']) <= seen,(term['id'],set(term['depends_on'])-seen)
 assert p['full_proposed_ontology'].count(f'<!-- organon:term {term["id"]} claim={term["claim_id"]} -->')==1
 seen.add(term['id'])
assert (D/'proposed-ontology.md').read_text()==p['full_proposed_ontology']
for definition in p['definitions']:
 assert definition['proposed_definition'] in p['full_proposed_ontology']
 assert definition['proposed_definition'] in (D/'pr18-source-packet.md').read_text()
 if definition['status']=='unchanged':assert definition['original_definition']==definition['proposed_definition']
for source in p['formal_sources']:
 assert hashlib.sha256((R/source['path']).read_bytes()).hexdigest()==source['sha256']
 if 'verbatim_source' in source:assert (R/source['path']).read_text()==source['verbatim_source']
for form in p['formal_forms']:
 source=(R/form['file']).read_text().splitlines()
 assert re.match(r'(structure|def) '+re.escape(form['symbol'])+r'\b',source[form['line']-1])
for term in ['Intention','Attention','SustainedAttention','AbsoluteAttention','Love','Care','Respect']:
 assert next(x for x in p['definitions'] if x['id']=='organon:'+term)['status']=='unchanged'
assert next(x for x in p['definitions'] if x['id']=='organon:EmbodiedSelfGovernance')['status']=='modified'
assert 'organon:Capability' not in p['proposed_contract_ledger']['statements'][0]['depends_on']
assert 'organon:Configuration' in p['proposed_contract_ledger']['statements'][0]['depends_on']
assert p['proposed_contract_ledger']['status']=='draft'
assert 'organon:Agency' not in p['proposed_contract_ledger']['statements'][0]['depends_on']
assert 'organon:Agency' not in p['proposed_contract_ledger']['statements'][0]['formal_contract']['dependency_dispositions']
assert p['proposed_contract_ledger']['statements'][0]['formal_contract']['status']=='proved_with_boundaries'
assert p['baseline_contract_ledger']==json.loads((R/'proposals/attention-love-care-claims.json').read_text())
for f in ['ontology/ontology.md','ontology/terms.yaml','ontology/formal/AttentionLoveCare.lean','ontology/formal/AttentionLoveCareContracts.lean']:
 assert (R/f).read_bytes()==subprocess.check_output(['git','show',p['base_commit']+':'+f],cwd=R)
print(f'Reading draft check passed: {len(seen)} ordered terms, {len(p["definitions"])} exact definition entries, {len(p["formal_forms"])} located field forms; seven PR18 paragraphs and both Attention sources unchanged.')
