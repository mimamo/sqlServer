USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_accthist_Acct]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_accthist_Acct]  @parm1 varchar (10), @parm2 varchar (24), @parm3 varchar (10), @parm4 varchar(4), @parm5 varchar (10) as
	select  * from accthist where    
	acct = @parm1  
	and sub = @parm2  
	and ledgerid = @parm3  
	and fiscyr = @parm4
	and cpnyid = @parm5  
	order by  acct, sub, ledgerid, fiscyr
GO
