USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990CountDocs]    Script Date: 12/21/2015 16:07:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[p08990CountDocs] @Batnbr VARCHAR (10) AS

SELECT NumOfDocs = Convert(float,Count(*))
  FROM ARDoc
 WHERE BatNbr = @Batnbr
GO
