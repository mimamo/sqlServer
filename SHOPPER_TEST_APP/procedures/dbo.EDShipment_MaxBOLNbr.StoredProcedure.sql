USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_MaxBOLNbr]    Script Date: 12/21/2015 16:07:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[EDShipment_MaxBOLNbr]
As
Select
	Max(BOLNbr) As 'MaxBOLNbr'
From
	EDShipment
GO
