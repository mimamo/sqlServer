USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ACCOUNT_SALL]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ACCOUNT_SALL] @parm1 varchar (10)  as
select * from ACCOUNT
where acct LIKE @parm1
order by acct
GO
