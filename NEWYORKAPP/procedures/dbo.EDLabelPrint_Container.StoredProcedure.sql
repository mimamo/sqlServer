USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDLabelPrint_Container]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDLabelPrint_Container] @ContainerId varchar(10) As
Update EDContainer Set LabelLastPrinted = GetDate() Where ContainerId = @ContainerId
GO
