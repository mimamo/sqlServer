USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ACCOUNT_SPK1]    Script Date: 12/21/2015 15:49:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ACCOUNT_SPK1] @parm1 varchar (10)  as
select * from ACCOUNT
where acct = @parm1
order by acct
GO
