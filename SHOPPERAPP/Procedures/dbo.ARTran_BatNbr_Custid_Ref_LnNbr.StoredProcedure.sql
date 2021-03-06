USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_BatNbr_Custid_Ref_LnNbr]    Script Date: 12/21/2015 16:13:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARTran_BatNbr_Custid_Ref_LnNbr    Script Date: 4/7/98 12:30:33 PM ******/
CREATE Procedure [dbo].[ARTran_BatNbr_Custid_Ref_LnNbr] @parm1 varchar ( 10), @parm2 varchar ( 15), @parm3 varchar ( 10), @parm4beg smallint, @parm4end smallint as
             Select * from ARTran where BatNbr = @parm1
             and CustId = @parm2
             and TranType IN ('PA','PP')
             and RefNbr = @parm3
             and LineNbr between @parm4beg and @parm4end
             and DrCr='D'
             order by CustId, RefNbr, LineNbr
GO
