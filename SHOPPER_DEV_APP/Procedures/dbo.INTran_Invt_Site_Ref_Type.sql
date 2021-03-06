USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[INTran_Invt_Site_Ref_Type]    Script Date: 12/16/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.INTran_Invt_Site_Ref_Type    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.INTran_Invt_Site_Ref_Type    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[INTran_Invt_Site_Ref_Type] @parm1 varchar ( 30) , @parm2 varchar ( 10) , @parm3 varchar ( 15) ,  @parm4 varchar ( 10)  as
Select * from INTran
	where InvtID = @parm1
	and Siteid = @parm2
	and Rlsed = 1
	and RefNbr <> @parm3
	and InSuffQty = 0
	and (TranType = 'RC' or TranType = 'TR' or TranType = 'OS' or (TranType = 'CG' and Acct = @parm4
	and RcptNbr > '0' and RcptNbr <> 'DP'))
Order By InvtId, SiteId, RcptNbr
GO
