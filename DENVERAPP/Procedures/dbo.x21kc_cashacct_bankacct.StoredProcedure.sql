USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_cashacct_bankacct]    Script Date: 12/21/2015 15:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_cashacct_bankacct] @parm1 varchar (10), @parm2 varchar (24), @parm3 varchar (10) as
	select  * from cashacct where
	bankacct = @parm1  
	AND  banksub = @parm2 
	AND cpnyid = @parm3
	order by  bankacct
GO
