USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_cashacct_banksub]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_cashacct_banksub] @parm1 varchar (24), @parm2 varchar (10), @parm3 varchar (10) as
	select  * from cashacct where
	banksub = @parm1  
	AND  bankacct = @parm2 
	AND cpnyid = @parm3
	order by  banksub
GO
