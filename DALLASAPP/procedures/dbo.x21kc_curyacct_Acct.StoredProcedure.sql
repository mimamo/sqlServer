USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_curyacct_Acct]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_curyacct_Acct]  @parm1 varchar (10), @parm2 varchar (24),  @parm3 varchar (10), @parm4 varchar (4),@parm5 varchar (4), @parm6 varchar (10) as
	select  * from curyacct where
	acct = @parm1  
	AND sub = @parm2 
	AND ledgerid =@parm3 
	AND fiscyr = @parm4  
	AND curyid = @parm5
        AND cpnyid = @parm6  
	order by acct
GO
