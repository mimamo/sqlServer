USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_pobudhist_sub]    Script Date: 12/21/2015 15:37:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_pobudhist_sub] @parm1 varchar (24), @parm2 varchar (10), @parm3 varchar (10), @parm4 varchar (4) as
	select  * from pobudhist where
	sub = @parm1  
	and acct = @parm2
	and curyid = @parm3
	and fiscyr = @parm4
	order by  sub
GO
