USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr_NoCustId]    Script Date: 12/21/2015 14:05:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ARDoc_BatNbr_NoCustId] @BatNbr as varchar(10) AS
SELECT *
FROM ARDoc
WHERE BatNbr = @BatNbr AND DocType <> 'RC' AND CustId = ''
GO
