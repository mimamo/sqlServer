USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARTran_UTran_CustID]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ARTran_UTran_CustID]  @CustID AS VARCHAR (15) AS
   SELECT * FROM ARTran WHERE CustID = @CustID and DrCr = 'U'
GO
