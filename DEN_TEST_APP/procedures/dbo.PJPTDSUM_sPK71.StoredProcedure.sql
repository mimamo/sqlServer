USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_sPK71]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_sPK71] @parm1 varchar (16)   as
SELECT *
FROM  pjptdsum P, pjacct A
WHERE
p.acct = a.acct and
a.acct_type = 'EX' and
p.project = @parm1
Order by
p.project,
p.pjt_entity,
p.acct
GO
