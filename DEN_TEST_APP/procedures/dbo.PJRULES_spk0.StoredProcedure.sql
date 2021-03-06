USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULES_spk0]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULES_spk0] @parm1 varchar (4) , @parm2 varchar (16) as
select *
from PJRULES
	left outer join PJACCT
		on PJRULES.acct = PJACCT.acct
where bill_type_cd = @parm1
	and PJRULES.acct like @parm2
order by PJRULES.bill_type_cd, PJRULES.acct
GO
