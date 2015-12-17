USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_BatNbr_NoCustId]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ARDoc_BatNbr_NoCustId] @BatNbr as varchar(10) AS
SELECT *
FROM ARDoc
WHERE BatNbr = @BatNbr AND DocType <> 'RC' AND CustId = ''
GO
