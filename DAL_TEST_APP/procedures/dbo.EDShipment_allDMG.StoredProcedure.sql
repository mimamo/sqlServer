USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_allDMG]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipment_allDMG] @BOLNbr varchar(20) As
Select * From EDShipment Where BOLNbr Like @BOLNbr
GO
