USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_855Check]    Script Date: 12/21/2015 16:07:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDSOHeader_855Check] @CpnyId varchar(10), @OrdNbr varchar(15) As
Select Count(*) From SOHeader A With (NoLock) Inner Join EDOutbound B On A.CustId = B.CustId Inner Join
ED850Header C On A.CpnyId = C.CpnyId And A.EDIPOID = C.EDIPOID Where
A.CpnyId = @CpnyId And A.OrdNbr = @OrdNbr And B.Trans = '855'
GO
