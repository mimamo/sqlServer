USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_RefNbr_Invt_Site_Bat]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_RefNbr_Invt_Site_Bat    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_RefNbr_Invt_Site_Bat    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_RefNbr_Invt_Site_Bat] @parm1 varchar ( 15) , @parm2 varchar ( 30) , @parm3 varchar ( 10)  as
Select * from INTran
	where RefNbr = @parm1
	and InvtID = @parm2
	and SiteID = @parm3
	and (TranType = 'IN' or TranType = 'AS')
Order by RefNbr DESC, InvtId DESC, SiteId DESC, BatNbr DESC, LineNbr DESC
GO
