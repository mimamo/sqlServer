USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810LineItem_InvtIdChk]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED810LineItem_InvtIdChk] @CpnyId varchar(10), @EDIInvId varchar(10), @PONbr varchar(10) As
Select InvtId From ED810LineItem Where CpnyId = @CpnyId And EDIInvId = @EDIInvId And InvtId Not In
(Select InvtId From PurOrdDet Where PONbr = @PONbr)
GO
