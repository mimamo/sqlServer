USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08310_SalesPerHistory]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08310_SalesPerHistory] @SlsPerID VARCHAR (10) AS

SELECT COUNT(*)
  FROM SlsPerHist
 WHERE SlsperId = @SlsPerID
GO
