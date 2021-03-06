USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xKC_OM_Grid]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc  [dbo].[xKC_OM_Grid] @type char(1),@cpnyid varchar(10)  as
if @type = 'S'
	select cpnyid = S1.cpnyid, S1.shipperid,  X.newshipperid, dupcpnyid = max(S2.cpnyid) 
	from soshipheader S1 
        left outer join xkcshipper X on S1.cpnyid = X.cpnyid and S1.shipperid = X.oldshipperid and X.newshipperid  <> '',
	soshipheader S2 
	where s1.cpnyid = @cpnyid
	and S2.cpnyid <> @cpnyid
	and S1.shipperid = S2.shipperid
	group by S1.cpnyid, S1.shipperid, x.newshipperid
	order by s1.cpnyid, s1.shipperid
else
	select cpnyid = S1.cpnyid, S1.ordnbr,  X.newordnbr , dupcpnyid = max(S2.cpnyid) 
	from soheader S1 
        left outer join xkcorder X on S1.cpnyid = X.cpnyid and S1.ordnbr = X.oldordnbr and X.newordnbr  <> '',
	soheader S2 
	where s1.cpnyid = @cpnyid
	and S2.cpnyid <> @cpnyid
	and S1.ordnbr = S2.ordnbr
	group by S1.cpnyid, S1.ordnbr, x.newordnbr
	order by s1.cpnyid, s1.ordnbr
GO
