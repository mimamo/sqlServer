USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xPJACCT_SALL]    Script Date: 12/21/2015 15:37:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[xPJACCT_SALL] @parm1 varchar (16)  as
select * from PJACCT
where acct like @parm1
and PJACCT.Acct_Status = 'A'
order by acct
GO
