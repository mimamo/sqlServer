USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[account_spk9]    Script Date: 12/21/2015 13:56:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[account_spk9] @parm1 varchar (250) , @parm2 varchar (10)  as
select * from  account
where acct = @parm2
order by acct
GO
