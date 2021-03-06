USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TaresPerItem]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_TaresPerItem] @CpnyId varchar(10), @ShipperId varchar(15), @InvtId varchar(30) As
Select Distinct A.TareId From EDContainer A Inner Join EDContainerDet B On A.CpnyId = B.CpnyId
And A.ShipperId = B.ShipperId And A.ContainerId = B.ContainerId Where A.CpnyId = @CpnyId
And A.ShipperId = @ShipperId And B.InvtId = @InvtId
GO
