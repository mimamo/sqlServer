USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_856Fields]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_856Fields] @ContainerId varchar(10) As
	Select Count(Distinct InvtId), Count(Distinct UOM), Sum(QtyShipped), Max(InvtId), Max(UOM)
	From EDContainerDet
	Where ContainerId = @ContainerId
GO
