USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_pobudhist_acct]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_pobudhist_acct] @parm1 varchar (10), @parm2 varchar (24), @parm3 varchar (10), @parm4 varchar (4) as
	select  * from pobudhist where
	acct = @parm1  
	and sub = @parm2
	and curyid = @parm3
	and fiscyr = @parm4
	order by  acct, sub, curyid, fiscyr
GO
