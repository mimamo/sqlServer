USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08310_SalesPerHistory]    Script Date: 12/21/2015 15:49:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08310_SalesPerHistory] @SlsPerID VARCHAR (10) AS

SELECT COUNT(*)
  FROM SlsPerHist
 WHERE SlsperId = @SlsPerID
GO
