USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Ap_balances_vendid]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_Ap_balances_vendid] @parm1 varchar (15), @parm2 varchar (10) as
	select  * from ap_balances where
	vendid = @parm1  
	AND cpnyid = @parm2 
	order by  vendid,cpnyid
GO
