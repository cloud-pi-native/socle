def diff_branches(source_branches, destination_branches):
  to_push = []
  to_delete = []
  for s in source_branches:
    present=False
    for d in destination_branches:
      if s['name'] == d['name']:
        present=True
        if s['commit']['sha'] != d['commit']['id']:
          to_push.append(s['name'])
    if not present:
      to_push.append(s['name'])
  for d in destination_branches:
    extra=True
    for s in source_branches:
      if s['name'] == d['name']:
        extra=False
    if extra:
      to_delete.append(d['name'])
  return { 
          'to_push': ' '.join(to_push),
          'to_delete': ' '.join(to_delete) 
        }

def diff_tags(source_tags, destination_tags):
  st = set([ s['name'] for s in source_tags ])
  dt = set([ d['name'] for d in destination_tags ])

  to_delete = dt.difference(st)
  to_push = []
  for s in source_tags:
    if not s['name'] in dt:
      to_push.append(s['name'])
      continue
    for d in destination_tags:
      if s['name'] == d['name'] and s['commit']['sha'] != d['target']:
        to_push.append(s['name'])
        continue
  
  return { 
          'to_delete': ' '.join(to_delete), 
          'to_push': ' '.join(to_push) 
        }

class FilterModule(object):  
    def filters(self):    
        return {
            'diff_branches': diff_branches,
            'diff_tags': diff_tags,
        }