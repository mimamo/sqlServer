USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Delete_BOL]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_Delete_BOL] @BOLNbr varchar(20) AS
Delete From EDShipment
Where BOLNbr = @BOLNbr
GO
