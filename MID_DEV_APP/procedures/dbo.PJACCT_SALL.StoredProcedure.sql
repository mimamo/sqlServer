USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJACCT_SALL]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJACCT_SALL] @parm1 varchar (16)  as
select * from PJACCT
where acct like @parm1
order by acct
GO
