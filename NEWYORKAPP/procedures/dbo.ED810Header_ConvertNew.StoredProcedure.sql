USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_ConvertNew]    Script Date: 12/21/2015 16:00:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_ConvertNew] @CpnyId varchar(10) As
Select CpnyId, EDIInvId From ED810Header A Inner Join EDVInbound B On A.VendId = B.VendId
Where A.UpdateStatus = 'OK' And B.ConvMeth <> 'DNC' And CpnyId = @CpnyId Order By CuryId
GO
