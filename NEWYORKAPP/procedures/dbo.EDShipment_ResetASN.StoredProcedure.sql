USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ResetASN]    Script Date: 12/21/2015 16:01:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_ResetASN] @BOLNbr varchar(20) As
Update EDShipment Set SendASN = 1 Where BOLNbr = @BOLNbr
GO
