USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_MaxLineNbr]    Script Date: 12/21/2015 13:44:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_MaxLineNbr] @ContainerId varchar(10) As
Select Max(LineNbr) From EDContainerDet Where ContainerId = @ContainerId
GO
