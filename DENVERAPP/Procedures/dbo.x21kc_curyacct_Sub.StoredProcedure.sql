USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_curyacct_Sub]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_curyacct_Sub] @parm1 varchar (24), @parm2 varchar (10),@parm3 varchar (10), @parm4 varchar (4), @parm5 varchar (4),  @parm6 varchar (10) as
	select  * from curyacct where
	sub = @parm1  
	AND acct = @parm2 
	AND ledgerid = @parm3 
	AND fiscyr = @parm4 
	AND curyid =  @parm5
	AND cpnyid = @parm6 
	order by  sub
GO
