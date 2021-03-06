USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[InTran_BMI_Sum_InvtId]    Script Date: 12/21/2015 15:49:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.InTran_BMI_Sum_InvtId    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.InTran_BMI_Sum_InvtId    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[InTran_BMI_Sum_InvtId] @parm1 varchar ( 30), @parm2 varchar ( 10) as
SELECT SUM(Qty), SUM(BMITranAmt) FROM INTran WHERE INTran.Invtid = @parm1 AND INTran.SiteId = @parm2 AND InSuffQty = 1 GROUP BY INTran.InvtId
GO
