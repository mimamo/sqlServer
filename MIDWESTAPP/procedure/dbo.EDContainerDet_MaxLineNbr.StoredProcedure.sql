USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainerDet_MaxLineNbr]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainerDet_MaxLineNbr] @ContainerId varchar(10) As
Select Max(LineNbr) From EDContainerDet Where ContainerId = @ContainerId
GO
