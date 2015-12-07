select h.invoice_num, d.project, d.project_billwith, d.draft_num, d.pjt_entity, p.pjt_entity_desc, p.user1, d.in_id18, pj.pm_id01, c.Name, d.amount
from 
PJINVDET d 
left outer join 
PJINVHDR h on D.project_billwith = H.project_billwith and d.draft_num = h.draft_num 
left outer join
PJPENT p on d.pjt_entity = p.pjt_entity and d.project = p.project
left outer join PJPROJ pj on	p.project = pj.project
left outer join Customer c on pj.pm_id01 = c.CustId
where h.invoice_num = '051815' 
and d.in_id18 <> 'NP'

