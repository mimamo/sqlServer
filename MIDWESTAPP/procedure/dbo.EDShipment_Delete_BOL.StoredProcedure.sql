USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_Delete_BOL]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_Delete_BOL] @BOLNbr varchar(20) AS
Delete From EDShipment
Where BOLNbr = @BOLNbr
GO
