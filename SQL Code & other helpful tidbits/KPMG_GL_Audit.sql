select * from gltran where jrnltype = 'CA' batnbr = '200642' projectID = '05032912AGY' and perent = '201209'

select * from gltran where projectid = '03753411AGY'


select * from batch where perpost = '201209' and jrnltype = 'APS'

select * from batch where batnbr = '200642'


select * from xwkmjg_time_det where projectnumber = '03753411AGY'



select b.batnbr, b.crtd_user , b.crtd_datetime, gl.lupd_datetime from batch b 
left outer join gltran gl on b.batnbr = gl.batnbr
where gl.jrnltype = 'CA' and gl.perpost like '2012%'
order by b.batnbr



