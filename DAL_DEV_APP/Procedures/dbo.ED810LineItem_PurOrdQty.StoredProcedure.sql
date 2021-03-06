USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_PurOrdQty]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810LineItem_PurOrdQty] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select A.LineId, A.QtyInvoiced, A.QtyInvoicedUOM, C.QtyOrd, C.QtyRcvd, C.PurchUnit,
C.RcptPctMin, C.RcptPctMax, C.CnvFact, C.UnitMultDiv
From ED810LineItem A Inner Join ED810Header B On A.CpnyId = B.CpnyId
And A.EDIInvId = B.EDIInvId Inner Join PurOrdDet C On B.PONbr = C.PONbr And A.POLineRef = C.LineRef
Where A.CpnyId = @CpnyId And A.EDIInvId = @EDIInvId And C.RcptPctAct = 'E' And A.QtyInvoicedUom <>
C.PurchUnit Order By A.CpnyId, A.EDIInvId, A.LineId
GO
