USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_DfltDist]    Script Date: 12/21/2015 16:00:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850SDQ_DfltDist] @CpnyId varchar(10), @EDIPOID varchar(10), @CustId varchar(15) As
Select A.LineId,A.SolShipToId From ED850SDQ A, EDSTCustomer B Where A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID
And B.CustId = @CustId And A.SolShipToId = B.ShipToId And LTrim(RTrim(B.DistCenterShipToId)) = ''
GO
