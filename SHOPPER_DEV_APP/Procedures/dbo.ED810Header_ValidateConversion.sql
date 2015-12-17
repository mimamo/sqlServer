USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_ValidateConversion]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810Header_ValidateConversion] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select Count(*) From ED810LineItem
Where CpnyId = @CpnyId And EDIInvId = @EDIInvId
Group By CpnyId, EDIInvId, InvtId, QtyInvoicedUOM
Having Sum(QtyInvoiced) <> IsNull((Select Sum(RcptQty) From POTran Where POTran.RcptNbr =
(Select POReceipt.RcptNbr From POReceipt Where POReceipt.S4Future11 = ED810LineItem.EDIInvId)
And POTran.InvtId = ED810LineItem.InvtId And POTran.RcptUnitDescr =
ED810LineItem.QtyInvoicedUOM),0)
GO
