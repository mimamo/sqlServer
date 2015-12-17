USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_Batch_Duplicates]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[ARDoc_Batch_Duplicates] @BatNbr as varchar(10) AS
SELECT Convert(SmallInt,CASE WHEN EXISTS(SELECT BatNbr, DocType, RefNbr, CustId
	FROM ARDoc
	WHERE BatNbr = @BatNbr AND CustId <> ''
	GROUP BY BatNbr, DocType, RefNbr, CustId
	HAVING Count(*) > 1) THEN 1 ELSE 0 END)
GO
