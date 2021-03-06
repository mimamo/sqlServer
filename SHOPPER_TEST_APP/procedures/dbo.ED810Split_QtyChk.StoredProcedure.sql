USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Split_QtyChk]    Script Date: 12/21/2015 16:07:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Split_QtyChk] @CpnyId varchar(10), @EDIInvId varchar(10) As
Select A.LineId From ED810LineItem A Inner Join ED810Split B On A.CpnyId = B.CpnyId And A.EDIInvId =
B.EDIInvId And A.LineId = B.LineId Where A.CpnyId = @CpnyId And A.EDIInvId = @EDIInvId
Group By A.LineId Having Avg(A.QtyInvoiced) <> Sum(B.QtyInvoiced)
GO
