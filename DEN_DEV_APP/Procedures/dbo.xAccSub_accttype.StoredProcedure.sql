USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_accttype]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[xAccSub_accttype] @parm1 varchar (10), @parm2 varchar (10) as
select   f.acct, f.accttype, t.acct, t.accttype from account f, account t
where f.acct = @parm1
and t.acct = @parm2
GO
