USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850Header_Verify]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ED850Header_Verify] @ISANbr int, @STNbr int, @CustId varchar(15) As
Select Count(*) From ED850Header A Inner Join ED850HeaderExt B On A.CpnyId = B.CpnyId And
  A.EDIPOID = B.EDIPOID Where A.CustId = @CustId And B.ISANbr = @ISANbr And
  B.STNBr = @STNbr
GO
