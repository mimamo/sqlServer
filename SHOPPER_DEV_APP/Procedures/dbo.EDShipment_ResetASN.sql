USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ResetASN]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDShipment_ResetASN] @BOLNbr varchar(20) As
Update EDShipment Set SendASN = 1 Where BOLNbr = @BOLNbr
GO
