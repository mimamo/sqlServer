USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_spk7]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_spk7] @parm1 varchar (16)  as
select b.*, p.*, x.*
from PJBILL b
	left outer join PJPROJEX x
		on b.project = x.project
	,PJPROJ p
where b.project = p.project and
b.project Like @parm1 and
p.status_pa = 'A'
order by b.project
GO
