USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAccSub_acct]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xAccSub_acct] @parm1 varchar (10) as
select acct   from account 
where acct = @parm1
order by acct
GO
