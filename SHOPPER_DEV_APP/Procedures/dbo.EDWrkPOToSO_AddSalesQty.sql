USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDWrkPOToSO_AddSalesQty]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDWrkPOToSO_AddSalesQty] @AccessNbr smallint
As
	Update EDWrkPOToSO
	Set SOQty = (Select IsNull(Sum(B.QtyOrd),0)
			From SOLine B
				Inner Join SOHeader C
					On 	B.CpnyId = C.CpnyId And
						B.OrdNbr = C.OrdNbr
			Where 	C.EDIPOID = A.EDIPOID And
				C.CpnyId = A.CpnyId And
				A.InvtId In (B.InvtId,B.AlternateId) And
				B.UnitDesc = A.POUOM And
				C.Cancelled = 0)
	From EDWrkPOToSO A
	Where AccessNbr = @AccessNbr
GO
