USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_ByPRO]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipment_ByPRO] @PRO varchar(30) As
Select * From EDShipment Where PRO = @PRO Order By BOLNbr
GO
