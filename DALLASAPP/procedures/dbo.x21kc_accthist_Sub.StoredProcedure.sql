USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_accthist_Sub]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_accthist_Sub] @parm1 varchar (24), @parm2 varchar (10), @parm3 varchar (10), @parm4 varchar (4),@parm5 varchar (10) as
	select  * from accthist where
	sub = @parm1  
	and acct = @parm2  
	and ledgerid = @parm3 
	and fiscyr = @parm4
        and cpnyid = @parm5  
	order by  sub, acct, fiscyr
GO
