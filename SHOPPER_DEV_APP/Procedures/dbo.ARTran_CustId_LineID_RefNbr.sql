USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_CustId_LineID_RefNbr]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_CustId_LineID_RefNbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARTran_CustId_LineID_RefNbr] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 8), @parm4 varchar ( 10), @parm5 smallint, @parm6 varchar ( 2), @parm7 varchar ( 10) as
  SELECT *
    FROM ARTran
   WHERE ARTran.BatNbr = @parm1
     AND ARTran.CustId = @parm2
     AND ARTran.CostType = @parm3
     AND ARTran.SiteId = @parm4
     AND ARTran.LineID = @parm5
     AND ARTran.TranType LIKE @parm6
     AND ARTran.RefNbr LIKE @parm7
     AND ARTran.DrCr = 'U'
   ORDER BY BatNbr, DrCr, CustId, TranType, RefNbr, Costtype, SiteId, RecordId
GO
