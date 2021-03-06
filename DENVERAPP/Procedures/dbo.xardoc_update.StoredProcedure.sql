USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xardoc_update]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xardoc_update] @userid varchar(47), @cpnyid varchar(10) as
delete from xardoc where userid = @userid
insert into xardoc (custid, name, OrigDocAmt,Refnbr,userid)
--mod 2/17/09 changed select to select distinct
select distinct c.custid, c.name,a.origdocamt, a.refnbr, @userid 
from ardoc a
join customer c on a.custid = c.custid
where a.doctype = 'IN'
and a.rlsed = 1
and a.cpnyid = @cpnyid
 --and a.refnbr not in (select adjdrefnbr from aradjust)
GO
