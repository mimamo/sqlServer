USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Ar_balances_custid]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_Ar_balances_custid] @parm1 varchar (15), @parm2 varchar (10) as
	select  * from ar_balances where
	custid = @parm1  
	AND cpnyid = @parm2 
	order by  custid
GO
