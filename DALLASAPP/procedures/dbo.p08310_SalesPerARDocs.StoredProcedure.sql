USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[p08310_SalesPerARDocs]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08310_SalesPerARDocs] @SlsPerID VARCHAR (10) AS

SELECT COUNT(*)
  FROM ARDoc
 WHERE SlsperId = @SlsPerID
GO
