USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_acct]    Script Date: 12/21/2015 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_acct] @parm1 varchar (10) as
select acct   from account 
where acct = @parm1
order by acct
GO
