select project from PJPROJ where manager1 = 'KZiegler' and status_pa = 'A'


select status_pa, * from PJPROJ where project = '07458912AGY'

select * from PJREVHDR where approver = 'KZiegler' and project IN (select project from PJPROJ where manager1 = 'KZiegler' --and status_pa = 'A')

select * from PJREVHDR where approver = 'KZiegler' and status = 'C' JFLUKE  

update PJREVHDR 
set approver = 'JFLUKE'
where approver = 'KZiegler' and status = 'C'

